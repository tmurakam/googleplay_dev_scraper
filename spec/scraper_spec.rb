# -*- coding: utf-8 -*-
require 'spec_helper'

describe GooglePlayScraper::Scraper do
  before do
    @scraper = GooglePlayScraper::Scraper.new
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

  
end

