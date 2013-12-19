class GooglePlayDevScraper::ApplicationStatistics
  DIMENSIONS = %i(overall os_version device country language app_version carrier)
  METRICS = %i(
    current_device_installs daily_device_installs daily_device_uninstalls
    daily_device_upgrades current_user_installs total_user_installs
    daily_user_installs daily_user_uninstalls daily_avg_rating total_avg_rating
  )
  STATISTICS_DOWNLOAD_HOST = 'play.google.com'
  STATISTICS_DOWNLOAD_PATH = '/apps/publish/statistics/download'

  class << self
    def fetch(package, options = {})
      uri = URI::HTTPS.build(
        host: STATISTICS_DOWNLOAD_HOST,
        path: STATISTICS_DOWNLOAD_PATH,
        query: URI.encode_www_form(
          dim: (options[:dimensions] || DIMENSIONS).join(','),
          met: (options[:metrics] || METRICS).join(','),
          package: options[:package]
        )
      )
    end
  end
end
