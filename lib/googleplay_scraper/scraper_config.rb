#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# = GooglePlay Scraper
# Author:: Takuya Murakami
# License:: Public domain

require 'mechanize'
require 'csv'
require 'yaml'

module GooglePlayScraper
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

    def load_config_file(path = nil)
      config_files = [ path, ".googleplay_scraper", "#{ENV['HOME']}/.googleplay_scraper" ]

      config_files.each do |file|
        if file && File.exists?(file)
          open(file) do |f|
            begin
              h = YAML.load(f.read)

              @email      ||= h['email']
              @password   ||= h['password']
              @dev_acc    ||= h['dev_acc']
              @proxy_host ||= h['proxy_host']
              @proxy_port ||= h['proxy_port']

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
    end
  end
end
