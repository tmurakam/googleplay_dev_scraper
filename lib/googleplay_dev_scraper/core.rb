module GooglePlayDevScraper
  class << self
    @@config = nil

    def config(options = {})
      @@config ||= ScraperConfig.new
      @@config.override_with(options) unless options.empty?
      @@config
    end

    def reset!
      @@config = nil
    end
  end
end
