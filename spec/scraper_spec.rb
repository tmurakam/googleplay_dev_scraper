# -*- coding: utf-8 -*-
require 'spec_helper'

describe GooglePlayScraper::Scraper do
  before do
    @scraper = ScraperMock.new

    @dev_acc = "1234567890"
    @scraper.dev_acc = @dev_acc
  end

  context "Setup" do
    it "setup without proxy" do
      @scraper.setup

      @scraper.agent.proxy_addr.should be_nil
      @scraper.agent.proxy_port.should be_nil
    end

    it "setup with proxy" do
      @scraper.proxy_host = "proxy.example.com"
      @scraper.proxy_port = 12345

      @scraper.setup

      @scraper.agent.proxy_addr.should == "proxy.example.com"
      @scraper.agent.proxy_port.should == 12345
    end
  end

  context "get sales report" do
    it "normal access" do
      @scraper.get_sales_report(2012, 11)
      @scraper.accessed_url.should == "https://play.google.com/apps/publish/salesreport/download?report_date=2012_11&report_type=payout_report&dev_acc=#{@dev_acc}"
    end
  end
  
end

