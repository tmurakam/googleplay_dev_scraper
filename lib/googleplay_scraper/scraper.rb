#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# = GooglePlay Scraper
# Author:: Takuya Murakami
# License:: Public domain

require 'mechanize'
require 'csv'
require 'yaml'
require 'date'

module GooglePlayScraper
  #
  # Google Play and google checkout scraper
  #
  class Scraper < ScraperBase

    def initialize
      super
    end

    def body_string
      @agent.page.body.force_encoding("UTF-8")
    end

    # Get sales report (report_type = payout_report)
    # [year]
    #   Year (ex. 2012)
    # [month]
    #   Month (1 - 12)
    # [Return]
    #   CSV string
    #
    def get_sales_report(year, month)
      #url = sprintf('https://play.google.com/apps/publish/salesreport/download?report_date=%04d_%02d&report_type=payout_report&dev_acc=%s', year, month, @config.dev_acc)
      url = sprintf('https://play.google.com/apps/publish/v2/salesreport/download?report_date=%04d_%02d&report_type=payout_report&dev_acc=%s', year, month, @config.dev_acc)
      try_get(url)

      body_string
    end

    # Get estimated sales report (report_type = sales_report)
    #
    # [year]
    #   Year (ex. 2012)
    # [month]
    #   Month (1 - 12)
    # [Return]
    #   CSV string
    #
    def get_estimated_sales_report(year, month)
      #https://play.google.com/apps/publish/v2/salesreport/download?report_date=2013_03&report_type=sales_report&dev_acc=09924472108471074593
      url = sprintf('https://play.google.com/apps/publish/v2/salesreport/download?report_date=%04d_%02d&report_type=sales_report&dev_acc=%s', year, month, @config.dev_acc)
      try_get(url)

      body_string
    end

    # Get order list
    #
    # [start_date]
    #   start time (DateTime)
    # [end_date]
    #   end time (DateTime)
    # [Return]
    #   CSV string
    def get_order_list(start_time, end_time)
      try_get("https://wallet.google.com/merchant/pages/")
      if @agent.page.uri.path =~ /(bcid-[^\/]+)\/(oid-[^\/]+)\/(cid-[^\/]+)\//
        bcid = $1
        oid = $2
        cid = $3

        # You can check the URL with your browser.
        # (download csv file, and check download history with chrome/firefox)
        try_get("https://wallet.google.com/merchant/pages/" +
                bcid + "/" + oid + "/" + cid +
                "/purchaseorderdownload?startTime=#{start_time.to_time.to_i * 1000}" + 
                "&endTime=#{end_time.to_i * 1000}"
        body_string
      end
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

      body_string
    end


    # Get order details page
    # [order_id]
    #   google order ID
    # [Return]
    #   CSV string
    def get_order_detail(order_id)
      try_get("https://checkout.google.com/sell/multiOrder?order=#{order_id}&ordersTable=1")

      body_string
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
      dim = "overall,country,language,os_version,device,app_version,carrier&met=active_device_installs,daily_device_installs,daily_device_uninstalls,daily_device_upgrades,active_user_installs,total_user_installs,daily_user_installs,daily_user_uninstalls,daily_avg_rating,total_avg_rating"
      url = "https://play.google.com/apps/publish/v2/statistics/download"
      url += "?package=#{package}"
      url += "&sd=#{start_day}&ed=#{end_day}"
      url += "&dim=#{dim}"
      #url += "&dev_acc=#{@config.dev_acc}"

      STDERR.puts "URL = #{url}"
      try_get(url)
      @agent.page.body
    end

    # Push all deliver buttons
    # [auto_archive]
    #   auto archive flag
    def auto_deliver(auto_archive = false)
      # access 'orders' page
      try_get("https://checkout.google.com/sell/orders")

      more_buttons = true

      # 押すべきボタンがなくなるまで、ボタンを押し続ける
      while more_buttons
        more_buttons = false

        @agent.page.forms.each do |form|
          order_id = nil
          order_field = form.field_with(:name => "OrderSelection")
          if order_field
            order_id = order_field.value
          end

          button = form.button_with(:name => "closeOrderButton")
          if button
            puts "Deliver : #{order_id}"
          elsif auto_archive
            button = form.button_with(:name => "archiveButton")
            if button
              puts "Archive : #{order_id}"
            end
          end

          if button
            form.click_button(button)
            more_buttons = true
            break
          end
        end
      end
    end

    # dump CSV (util)
    def dump_csv(csv_string)
      headers = nil
      CSV.parse(csv_string) do |row|
        unless headers
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

    #
    # Get order list from wallet html page
    #
    def get_wallet_orders
      try_get("https://wallet.google.com/merchant/pages/")
      html = body_string

      doc = Nokogiri::HTML(html)

      #doc.xpath("//table[@id='purchaseOrderListTable']")

      result = ""

      doc.xpath("//tr[@class='orderRow']").each do |e|
        order_id = e['id']

        date = nil
        desc = nil
        total = nil
        status = nil

        e.children.each do |e2|
          case e2['class']
          when /wallet-date-column/
            date = e2.content
          when /wallet-description-column/
            desc = e2.content
          when /wallet-total-column/
            total = e2.content
          when /wallet-status-column/
            e3 = e2.children.first
            status = e3['title'] unless e3.nil?
          end
        end

        result += [order_id, date, desc, status, total].join(",") + "\n"
      end

      result
    end
  end
end
