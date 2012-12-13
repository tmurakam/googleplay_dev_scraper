#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# = GooglePlay Scraper
# Author:: Takuya Murakami
# License:: Public domain

require 'rubygems'

gem 'mechanize'#, '1.0.0'
require 'mechanize'

require 'csv'

module GooglePlayScraper
  #
  # Google Play and goole checkout scraper
  #
  class Scraper
    # Google account
    attr_accessor :email

    # Password to login google account
    attr_accessor :password

    # developer account ID
    attr_accessor :dev_acc

    # HTTP proxy host
    attr_accessor :proxy_host
    
    # HTTP proxy port
    attr_accessor :proxy_port

    attr_accessor :agent

    def initialize
      @agent = nil
    end
  
    def setup
      #Mechanize.log = Logger.new("mechanize.log")
      #Mechanize.log.level = Logger::INFO

      unless @agent
        @agent = Mechanize.new
      end
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

    # Get sales report
    # [year]
    #   Year (ex. 2012)
    # [month]
    #   Month (1 - 12)
    # [Return]
    #   CSV string
    #
    def get_sales_report(year, month)
      #url = sprintf('https://market.android.com/publish/salesreport/download?report_date=%04d_%02d', year, month)
      url = sprintf('https://play.google.com/apps/publish/salesreport/download?report_date=%04d_%02d&report_type=payout_report&dev_acc=%s', year, month, @dev_acc)
      try_get(url)
      return @agent.page.body.force_encoding("UTF-8")
    end
    
    # Get estimated sales report
    #
    # [year]
    #   Year (ex. 2012)
    # [month]
    #   Month (1 - 12)
    # [Return]
    #   CSV string
    #
    def get_estimated_sales_report(year, month)
      url = sprintf('https://play.google.com/apps/publish/salesreport/download?report_date=%04d_%02d&report_type=sales_report&dev_acc=%s', year, month, @dev_acc)
      try_get(url)
      return @agent.page.body.force_encoding("UTF-8")
    end

    # Get order list
    #
    # [start_date]
    #   start date (yyyy-MM-ddThh:mm:ss)
    # [end_date]
    #   end date (yyyy-MM-ddThh:mm:ss)
    # [state]
    #   financial state, one of followings:
    #   ALL, CANCELLED, CANCELLED_BY_GOOGLE, CHARGEABLE, CHARGED,
    #   CHARGING, PAYMENT_DECLINED, REVIEWING
    # [expanded]
    #   true - expanded list, false - normal list
    # [Return]
    #   CSV string
    def get_order_list(start_date, end_date, state = "CHARGED", expanded = false)

      try_get("https://checkout.google.com/sell/orders")

      @agent.page.form_with(:name => "dateInput") do |form|
        form["start-date"] = start_date
        form["end-date"] = end_date
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

      return @agent.page.body.force_encoding("UTF-8")
    end

    
    # Get payout report
    #
    # [start_day]
    #   start day (yyyy-MM-dd)
    # [end_day]
    #   end day (yyyy-MM-dd)
    # [type]
    #   PAYOUT_REPORT or TRANSACTION_DETAIL_REPORT
    # [Return]
    #   CSV string
    def get_payouts(start_day, end_day, type = "PAYOUT_REPORT")

      try_get("https://checkout.google.com/sell/payouts")

      @agent.page.form_with(:name => "btRangeReport") do |form|
        form["startDay"] = "d:" + start_day.to_s
        form["endDay"] = "d:" + end_day.to_s
        #form["reportType"] = type
        form.radiobutton_with(:value => type).check

        form.click_button
      end

      return @agent.page.body.force_encoding("UTF-8")
    end


    # Get order details page
    # [orderId]
    #   google order ID
    # [Return]
    #   CSV string
    def get_order_detail(orderId)
      try_get("https://checkout.google.com/sell/multiOrder?order=#{orderId}&ordersTable=1")
      return @agent.page.body.force_encoding("UTF-8")
    end

    # Get application statistics CSV in zip
    #
    # [package]
    #   package name
    # [start_day]
    #   start date (yyyyMMdd)
    # [end_day]
    #   end date (yyyyMMdd)
    # [Return]
    #   application statics zip data
    #
    def get_appstats(package, start_day, end_day)
      dim = "overall,country,language,os_version,device,app_version,carrier&met=daily_device_installs,active_device_installs,daily_user_installs,total_user_installs,active_user_installs,daily_device_uninstalls,daily_user_uninstalls,daily_device_upgrades"

      url = "https://play.google.com/apps/publish/statistics/download"
      url += "?package=#{package}"
      url += "&sd=#{start_day}&ed=#{end_day}"
      url += "&dim=#{dim}"
      url += "&dev_acc=#{@dev_acc}"

      puts url
      try_get(url)
      return @agent.page.body
    end

    # Push all deliver buttons
    # [auto_archive]
    #   auto archive flag
    def auto_deliver(auto_archive = false)
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
end
