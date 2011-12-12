#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require './android_checkout_scraper'
require './secrets.rb'

scraper = AndroidCheckoutScraper.new

#scraper.proxy_host = 'proxyhost'
#scraper.proxy_port = 3128

scraper.email = $email_address
scraper.password = $password

scraper.login

csv = scraper.getSalesReport(2011, 10)
#csv = scraper.getOrderList("2011-11-01T00:00:00", "2011-11-30T23:59:59")

puts csv
#scraper.dumpCsv(csv)
