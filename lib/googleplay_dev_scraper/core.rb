module GooglePlayDevScraper
  class << self
    @@config = nil
    @@agent = nil

    def config(options = {})
      @@config ||= ScraperConfig.new
      @@config.override_with(options) unless options.empty?
      @@config
    end

    def agent
      @@agent ||= Mechanize.new
      if config.proxy_host && !config.proxy_host.empty?
        @@agent.set_proxy(config.proxy_host, config.proxy_port)
      end
      @@agent
    end

    def reset!
      @@config = nil
      @@agent = nil
    end
  end
end
