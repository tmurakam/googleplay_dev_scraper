#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# = GooglePlay Scraper
# Author:: Takuya Murakami
# License:: Public domain

require 'mechanize'
require 'csv'
require 'yaml'

module GooglePlayDevScraper
  class ScraperBase
    attr_accessor :agent, :config, :last_response, :last_response_body


    def initialize
      @config = GooglePlayDevScraper.config
      @agent = GooglePlayDevScraper.agent
    end

    def try_get(url)
      @agent.post_connect_hooks << lambda{|agent, uri, response, res_body|
        @last_response = response
        @last_response_body = res_body
      }

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
