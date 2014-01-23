module GooglePlayDevScraper
  class << self
    def config(options = {})
      config = ScraperConfig.new
      config.set_options(options)
      config
    end

    def agent(config)
      agent = Mechanize.new
      if config.proxy_host && !config.proxy_host.empty?
        agent.set_proxy(config.proxy_host, config.proxy_port)
      end
      agent
    end
  end
end
