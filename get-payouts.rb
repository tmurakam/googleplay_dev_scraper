#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require './android_checkout_scraper'
require './secrets.rb'
require './config.rb'

if (ARGV.size < 2)
  STDERR.puts "Usage: #{$0} <start_date> <end_date> [<type>]"
  exit 1
end

startdate = Date.parse(ARGV[0])
enddate = Date.parse(ARGV[1])
if (ARGV.size >= 3)
  type = ARGV[2]
else
  type = "PAYOUT_REPORT"
end

scraper = AndroidCheckoutScraper.new
if ($proxy_host != nil)
  scraper.proxy_host = $proxy_host
  scraper.proxy_port = $proxy_port
end

scraper.email = $email_address
scraper.password = $password

csv = scraper.getPayouts(startdate, enddate, type)
puts csv
#scraper.dumpCsv(csv)

