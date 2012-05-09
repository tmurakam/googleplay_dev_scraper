#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'optparse'

require './android_checkout_scraper'
require './secrets.rb'
require './config.rb'

details = false

opts = OptionParser.new
opts.on("--details", "Show expanded format") {|v| details = true }
opts.parse!(ARGV)

if (ARGV.size < 2)
  STDERR.puts "Usage: #{$0} [options] <start_date> <end_date> [<state>]"
  STDERR.puts "       #{$0} --help"
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

csv = scraper.getOrderList(startdate, enddate, state, details)
puts csv
#scraper.dumpCsv(csv)
