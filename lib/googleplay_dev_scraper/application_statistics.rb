class GooglePlayDevScraper::ApplicationStatistics
  DIMENSIONS = %w(
    overall os_version device country language app_version carrier
    gcm_message_status gcm_response_code crash_details anr_details
  )
  METRICS = %w(
    current_device_installs daily_device_installs daily_device_uninstalls
    daily_device_upgrades current_user_installs total_user_installs
    daily_user_installs daily_user_uninstalls daily_avg_rating total_avg_rating
    gcm_messages gcm_registrations daily_crashes daily_anrs
  )
  STATISTICS_DOWNLOAD_HOST = 'play.google.com'
  STATISTICS_DOWNLOAD_PATH = '/apps/publish/statistics/download'

  attr_reader :date, :dimension, :field_name, :entries

  def initialize(options = {})
    options.each do |attr, value|
      instance_variable_set("@#{attr}", value)
    end
  end

  class << self
    def fetch(package, options = {})
      dimensions = options[:dimensions] || DIMENSIONS
      metrics = options[:metrics] || METRICS
      uri = URI::HTTPS.build(
        host: STATISTICS_DOWNLOAD_HOST,
        path: STATISTICS_DOWNLOAD_PATH,
        query: URI.encode_www_form(
          dim: dimensions.join(','),
          met: metrics.join(','),
          package: package,
          sd: (options[:start_date] || Date.today - 7).strftime('%Y%m%d'),
          ed: (options[:end_date] || Date.today).strftime('%Y%m%d')
        )
      )
      scraper = GooglePlayDevScraper::ScraperBase.new
      scraper.try_get(uri.to_s)
      entries = []
      case scraper.last_response.content_type
      when 'text/csv'
        entries = parse_csv(dimensions.first, scraper.last_response_body)
      when 'application/zip'
        tempfile = Tempfile.new('csv.zip')
        tempfile.write(scraper.last_response_body)
        tempfile.rewind
        zipfile = Zip::File.new(tempfile.path)
        entries = zipfile.map {|entry|
          matches = %r{\A#{Regexp.escape(package)}_(.*)_((installs)|(ratings)|(gcm)|(crashes)).csv\Z}.match(entry.name)
          if matches && matches[1] && matches[2]
            entry_stream = zipfile.get_input_stream(entry)
            parse_csv(matches[1], entry_stream.read)
          else
            raise StandardError.new 'unexpected file name'
          end
        }.flatten
      else
        raise StandardError.new 'unexpected response content type'
      end
      GooglePlayDevScraper::ApplicationStatisticsCollection.new(entries)
    end

    def parse_csv(dimension, csv_data)
      lines = csv_data.split("\n")
      4.times{ lines.shift }
      entries_per_date = {}
      CSV.parse(lines.join("\n"), headers: true).each do |line|
        date = line.delete('date').last
        if entries_per_date.has_key?(date)
          entries_per_date[date] << line
        else
          entries_per_date[date] = [ line ]
        end
      end
      statistics = entries_per_date.map do |date, lines|
        headers = lines.first.headers.clone
        primary_key_name = 'overall'
        if headers.first == dimension
          primary_key_name = headers.shift
        end
        values_per_params = {}
        headers.each { |field_name| values_per_params[field_name] = Hash.new }

        lines.each do |line|
          column_name = line[primary_key_name] || primary_key_name
          headers.each do |field_name|
            values_per_params[field_name][column_name] = line[field_name].to_i
          end
        end

        values_per_params.map do |header, entries|
          self.new(
            date: Date.parse(date),
            dimension: dimension.to_sym,
            field_name: header.to_sym,
            entries: entries
          )
        end
      end

      statistics.flatten
    end
  end
end
