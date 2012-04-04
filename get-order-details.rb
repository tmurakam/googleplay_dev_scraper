#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require './android_checkout_scraper'
require './secrets.rb'
require './config.rb'

if (ARGV.size < 1)
  STDERR.puts "Usage: #{$0} order_id"
  exit 1
end

orderId = ARGV[0]

scraper = AndroidCheckoutScraper.new
if ($proxy_host != nil)
  scraper.proxy_host = $proxy_host
  scraper.proxy_port = $proxy_port
end

scraper.email = $email_address
scraper.password = $password

body = scraper.getOrderDetail(orderId)
puts body
