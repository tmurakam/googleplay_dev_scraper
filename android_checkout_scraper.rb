#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'rubygems'

gem 'mechanize', '1.0.0'
require 'mechanize'

require 'csv'

#
# Google checkout scraper for Android
#
class AndroidCheckoutScraper
  attr_accessor :proxy_host, :proxy_port, :email, :password
  
  def initialize
    @agent = nil
  end
  
  def setup
    #Mechanize.log = Logger.new("mechanize.log")
    #Mechanize.log.level = Logger::INFO

    @agent = Mechanize.new
    if (@proxy_host && @proxy_host.length >= 1)
      @agent.set_proxy(@proxy_host, @proxy_port)
    end
  end

  # Login
  def login
    unless @agent
      setup
    end

    target_uri = 'https://market.android.com/publish/Home'

    @agent.get(target_uri)

    if (@agent.page.uri.host != "accounts.google.com" ||
        @agent.page.uri.path != "/ServiceLogin")
      STDERR.puts "Invalid login url... : uri = #{@agent.page.uri}"
      raise 'Google server connection error'
    end

    form = @agent.page.forms.find {|f| f.form_node['id'] == "gaia_loginform"}
    if (!form)
      raise 'No login form'
    end
    form.field_with(:name => "Email").value = @email
    form.field_with(:name => "Passwd").value = @password
    form.click_button

    if (@agent.page.uri.to_s != target_uri)
      STDERR.puts "login failed? : uri = " + @agent.page.uri.to_s
      raise 'Google login failed'
    end
  end

  # Get merchant sales report
  def getSalesReport(year, month)
    url = sprintf('https://market.android.com/publish/salesreport/download?report_date=%04d_%02d', year, month)
    @agent.get(url)
    return @agent.page.body
  end

  # Get order list
  # startDate: start date (yyyy-mm-ddThh:mm:ss)
  # end: end date (yyyy-mm-ddThh:mm:ss)
  def getOrderList(startDate, endDate)
    @agent.get("https://checkout.google.com/sell/orders")

    @agent.page.form_with(:name => "dateInput") do |form|
      form["start-date"] = startDate
      form["end-date"] = endDate
      form["financial-state"] = "CHARGED"
      form["column-style"] = "EXPANDED"
      #form["date-time-zone"] = "Asia/Tokyo"
      #form["_type"] = "order-list-request"
      #form["query-type"] = ""
      form.click_button
    end

    return @agent.page.body
  end

  # dump CSV (util)
  def dumpCsv(csv_string)
    headers = nil
    CSV.parse(csv_string) do |row|
      if (!headers)
        headers = row
        next
      end

      i = 0
      row.each do |column|
        puts "#{headers[i]} : #{column}"
        i = i + 1
      end
      puts
    end
  end
end


