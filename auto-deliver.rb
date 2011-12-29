#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require './android_checkout_scraper'
require './secrets.rb'

scraper = AndroidCheckoutScraper.new

scraper.email = $email_address
scraper.password = $password

scraper.autoDeliver

# If you want to "archive" orders, use this.
# scraper.autoDeliver true
