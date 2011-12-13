#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require './android_checkout_scraper'
require './secrets.rb'

if (ARGV.size < 2)
  STDERR.puts "Usage: #{$0} <start_date> <end_date> [<type>]"
  exit 1
end

startdate = ARGV[0]
enddate = ARGV[1]
if (ARGV.size >= 3)
  type = ARGV[2]
else
  type = "PAYOUTS"
end

scraper = AndroidCheckoutScraper.new

scraper.email = $email_address
scraper.password = $password

csv = scraper.getPayouts("d:" + startdate, "d:" + enddate)
puts csv
#scraper.dumpCsv(csv)

