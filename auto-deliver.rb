#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require './android_checkout_scraper'
require './secrets.rb'

scraper = AndroidCheckoutScraper.new

scraper.email = $email_address
scraper.password = $password

auto_archive = false
if (ARGV[0] == "-a")
  auto_archive = true
end

scraper.autoDeliver auto_archive
