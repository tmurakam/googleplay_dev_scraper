#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# = GooglePlay Scraper
# Author:: Takuya Murakami
# License:: Public domain

require 'mechanize'
require 'csv'
require 'yaml'

module GooglePlayScraper
  class ScraperBase
    attr_accessor :agent
    attr_accessor :config

    def initialize
      @agent = nil
      @config = ScraperConfig.new
    end

    def setup
      #Mechanize.log = Logger.new("mechanize.log")
      #Mechanize.log.level = Logger::INFO

      unless @agent
        @agent = Mechanize.new
      end
      if @config.proxy_host && @config.proxy_host.length >= 1
        @agent.set_proxy(@config.proxy_host, @config.proxy_port)
      end
    end

    def try_get(url)
      unless @agent
        setup
      end

      # try to get
      @agent.get(url)

      # login needed?
      if @agent.page.uri.host != "accounts.google.com" || @agent.page.uri.path != "/ServiceLogin"
        # already login-ed
        return
      end

      # do login
      form = @agent.page.forms.find {|f| f.form_node['id'] == "gaia_loginform"}
      unless form
        raise 'No login form'
      end
      form.field_with(:name => "Email").value = @config.email
      form.field_with(:name => "Passwd").value = @config.password
      form.click_button

      if @agent.page.uri.host == "accounts.google.com"
        STDERR.puts "login failed? : uri = " + @agent.page.uri.to_s
        raise 'Google login failed'
      end

      # retry get
      @agent.get(url)
    end
  end
end
