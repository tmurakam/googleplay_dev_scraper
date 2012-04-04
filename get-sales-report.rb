#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require './android_checkout_scraper'
require './secrets.rb'
require './config.rb'

if (ARGV.size != 2)
  STDERR.puts "Usage: #{$0} <year> <month>"
  exit 1
end

year = ARGV[0].to_i
month = ARGV[1].to_i

scraper = AndroidCheckoutScraper.new
if ($proxy_host != nil)
  scraper.proxy_host = $proxy_host
  scraper.proxy_port = $proxy_port
end

scraper.email = $email_address
scraper.password = $password
scraper.dev_acc = $dev_acc

csv = scraper.getSalesReport(year, month)
puts csv
