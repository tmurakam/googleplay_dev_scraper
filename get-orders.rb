#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require './android_checkout_scraper'
require './secrets.rb'

if (ARGV.size != 2)
  STDERR.puts "Usage: #{$0} <start_date> <end_date>"
  exit 1
end

startdate = ARGV[0]
enddate = ARGV[1]

scraper = AndroidCheckoutScraper.new

scraper.email = $email_address
scraper.password = $password

scraper.login

csv = scraper.getOrderList(startdate, enddate)
puts csv
