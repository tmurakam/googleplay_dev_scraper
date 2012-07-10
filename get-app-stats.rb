#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require './android_checkout_scraper'
require './secrets.rb'
require './config.rb'

if (ARGV.size < 1)
  STDERR.puts "Usage: #{$0} package_name startDay endDay"
  STDERR.puts "  date format = yyyyMMdd"
  exit 1
end

package = ARGV[0]
startDay = ARGV[1]
endDay = ARGV[2]

scraper = AndroidCheckoutScraper.new
if ($proxy_host != nil)
  scraper.proxy_host = $proxy_host
  scraper.proxy_port = $proxy_port
end

scraper.email = $email_address
scraper.password = $password
scraper.dev_acc = $dev_acc

body = scraper.getAppStats(package, startDay, endDay)
puts body
