#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# = GooglePlay dev Scraper
# Author:: Takuya Murakami
# License:: Public domain

require 'mechanize'
require 'csv'
require 'yaml'

module GooglePlayDevScraper
  #
  # Configurations
  #
  class ScraperConfig
    # Google account
    attr_accessor :email

    # Password to login google account
    attr_accessor :password

    # developer account ID
    attr_accessor :dev_acc

    # HTTP proxy host
    attr_accessor :proxy_host

    # HTTP proxy port
    attr_accessor :proxy_port

    def initialize
      @dev_acc = nil
    end

    def load_config(path = nil)
      config_files = [ path, ".googleplay_dev_scraper", "#{ENV['HOME']}/.googleplay_dev_scraper" ]

      config_files.each do |file|
        load_config_file(file)
      end
    end

    def load_config_file(file)
      if file && File.exists?(file)
        open(file) do |f|
          begin
            read_config(f.read)
          rescue Psych::SyntaxError => e
            STDERR.puts "Error: configuration file syntax: #{file}"
            exit 1
          rescue
            STDERR.puts "Error: load configuration file: #{file}"
            exit 1
          end
        end
      end
    end

    def read_config(data)
      h = YAML.load(data)
      if h
        @email      ||= h['email']
        @password   ||= h['password']
        @dev_acc    ||= h['dev_acc']
        @proxy_host ||= h['proxy_host']
        @proxy_port ||= h['proxy_port']
      end
    end

    def set_options(options = {})
      @email = options[:email] if options[:email]
      @password = options[:password] if options[:password]
      @dev_acc = options[:dev_acc] if options[:dev_acc]
      @proxy_host = options[:proxy_host] if options[:proxy_host]
      @proxy_port = options[:proxy_port] if options[:proxy_port]
    end

    def override_with(options = {})
      @email = options[:email]
      @password = options[:password]
      @dev_acc = options[:dev_acc]
      @proxy_host = options[:proxy_host]
      @proxy_port = options[:proxy_port]
    end
  end
end
