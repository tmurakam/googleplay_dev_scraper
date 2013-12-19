# -*- coding: utf-8 -*-
require 'spec_helper'

describe GooglePlayDevScraper::Scraper do
  let(:scraper) { GooglePlayDevScraper::Scraper.new }
  let(:dev_acc) { '1234567890' }

  describe "Setup" do
    it "setup without proxy" do
      scraper.agent.proxy_addr.should be_nil
      scraper.agent.proxy_port.should be_nil
    end

    it "setup with proxy" do
      GooglePlayDevScraper.config(
        proxy_host: 'proxy.example.com',
        proxy_port: 12345
      )
      scraper.agent.proxy_addr.should == "proxy.example.com"
      scraper.agent.proxy_port.should == 12345
    end
  end

  describe "get sales report" do
    let(:stub_google_play_request) do
      stub_request(:get, 'https://play.google.com/apps/publish/v2/salesreport/download').with(
        query: {
          report_date: '2012_11',
          report_type: 'payout_report',
          dev_acc: dev_acc
        }
      )
    end

    before { stub_google_play_request }

    it "normal access" do
      scraper.config.dev_acc = dev_acc
      scraper.get_sales_report(2012, 11)
      stub_google_play_request.should have_been_made.once
    end
  end

  after { GooglePlayDevScraper.reset! }
end

