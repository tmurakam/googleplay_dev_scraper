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
  # Google account credencial
  attr_accessor :email, :password, :dev_acc

  # proxy settings
  attr_accessor :proxy_host, :proxy_port
  
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

  def try_get(url)
    unless @agent
      setup
    end

    # try to get
    @agent.get(url)

    # login needed?
    if (@agent.page.uri.host != "accounts.google.com" ||
        @agent.page.uri.path != "/ServiceLogin")
      # already logined
      return
    end

    # do login
    form = @agent.page.forms.find {|f| f.form_node['id'] == "gaia_loginform"}
    if (!form)
      raise 'No login form'
    end
    form.field_with(:name => "Email").value = @email
    form.field_with(:name => "Passwd").value = @password
    form.click_button

    if (@agent.page.uri.host == "accounts.google.com")
      STDERR.puts "login failed? : uri = " + @agent.page.uri.to_s
      raise 'Google login failed'
    end

    # retry get
    @agent.get(url)
  end

  # Get merchant sales report
  def getSalesReport(year, month)
    #url = sprintf('https://market.android.com/publish/salesreport/download?report_date=%04d_%02d', year, month)
    url = sprintf('https://play.google.com/apps/publish/salesreport/download?report_date=%04d_%02d&report_type=payout_report&dev_acc=%s', year, month, @dev_acc)
    try_get(url)
    return @agent.page.body
  end
  
  # Get merchant etimated sales report
  def getEstimatedSalesReport(year, month)
    url = sprintf('https://play.google.com/apps/publish/salesreport/download?report_date=%04d_%02d&report_type=sales_report&dev_acc=%s', year, month, @dev_acc)
    try_get(url)
    return @agent.page.body
  end

  # Get order list
  # startDate: start date (yyyy-mm-ddThh:mm:ss)
  # end: end date (yyyy-mm-ddThh:mm:ss)
  # state: financial state, one of followings:
  #   ALL, CANCELLED, CANCELLED_BY_GOOGLE, CHARGEABLE, CHARGED,
  #   CHARGING, PAYMENT_DECLINED, REVIEWING
  def getOrderList(startDate, endDate, state = "CHARGED", expanded = false)

    try_get("https://checkout.google.com/sell/orders")

    @agent.page.form_with(:name => "dateInput") do |form|
      form["start-date"] = startDate
      form["end-date"] = endDate
      if (state == "ALL")
        form.delete_field!("financial-state")
      else
        form["financial-state"] = state
      end
      if (expanded)
        form["column-style"] = "EXPANDED"
      end
      #form["date-time-zone"] = "Asia/Tokyo"
      #form["_type"] = "order-list-request"
      #form["query-type"] = ""
      form.click_button
    end

    return @agent.page.body
  end

  
  # get payout report
  #
  # type: PAYOUT_REPORT or TRANSACTION_DETAIL_REPORT
  def getPayouts(startDay, endDay, type = "PAYOUT_REPORT")

    try_get("https://checkout.google.com/sell/payouts")

    @agent.page.form_with(:name => "btRangeReport") do |form|
      form["startDay"] = "d:" + startDay.to_s
      form["endDay"] = "d:" + endDay.to_s
      #form["reportType"] = type
      form.radiobutton_with(:value => type).check

      form.click_button
    end

    return @agent.page.body
  end


  # get order details page
  def getOrderDetail(orderId)
    try_get("https://checkout.google.com/sell/multiOrder?order=#{orderId}&ordersTable=1")
    return @agent.page.body
  end

  # push all deliver buttons
  def autoDeliver(auto_archive = false)
    # access 'orders' page
    try_get("https://checkout.google.com/sell/orders")

    more_buttons = true

    # 押すべきボタンがなくなるまで、ボタンを押し続ける
    while(more_buttons)
      more_buttons = false

      @agent.page.forms.each do |form|
        order_id = nil
        order_field = form.field_with(:name => "OrderSelection")
        if (order_field)
            order_id = order_field.value
        end

        button = form.button_with(:name => "closeOrderButton")
        if (button)
          puts "Deliver : #{order_id}"
        elsif (auto_archive)
          button = form.button_with(:name => "archiveButton")
          if (button)
              puts "Archive : #{order_id}"
          end
        end

        if (button)
          form.click_button(button)
          more_buttons = true
          break
        end
      end
    end
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


