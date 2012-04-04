#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require './android_checkout_scraper'
require './secrets.rb'
require './config.rb'

if (ARGV.size < 2)
  STDERR.puts "Usage: #{$0} <start_date> <end_date> [<state>]"
  exit 1
end

startdate = ARGV[0]
enddate = ARGV[1]
if (ARGV.size >= 3)
  state = ARGV[2]
else
  state = "CHARGED"
end

scraper = AndroidCheckoutScraper.new
if ($proxy_host != nil)
  scraper.proxy_host = $proxy_host
  scraper.proxy_port = $proxy_port
end

scraper.email = $email_address
scraper.password = $password

csv = scraper.getOrderList(startdate, enddate, state)
puts csv
#scraper.dumpCsv(csv)
