# -*- coding: utf-8 -*-
require 'spec_helper'

describe GooglePlayDevScraper::ScraperConfig do
  before do
    @config = GooglePlayDevScraper::ScraperConfig.new
  end

  context "read_config" do
    it "read empty config" do
      yaml = <<EOF
# no data
EOF
      @config.read_config(yaml)

      @config.email.should be_nil
      @config.password.should be_nil
      @config.dev_acc.should be_nil
      @config.proxy_host.should be_nil
      @config.proxy_port.should be_nil
    end

    it "read normal config" do
      yaml = <<EOF
email: EMAIL
password: PASSWORD
dev_acc: DEV_ACC
proxy_host: PROXY_HOST
proxy_port: PROXY_PORT
EOF
      @config.read_config(yaml)

      @config.email.should == "EMAIL"
      @config.password.should == "PASSWORD"
      @config.dev_acc.should == "DEV_ACC"
      @config.proxy_host.should == "PROXY_HOST"
      @config.proxy_port.should == "PROXY_PORT"
    end
  end

  context "load_config" do
    before do 
      # make mock
      def @config.load_config_file(file)
        @config_files ||= Array.new
        @config_files.push(file)
      end

      def @config.config_files
        @config_files
      end
    end

    it "without path" do
      @config.load_config
      a = @config.config_files.should ==
        [ nil, ".googleplay_dev_scraper", ENV['HOME'] + "/.googleplay_dev_scraper"]
    end

    it "with path" do
      @config.load_config("/some/path")
      a = @config.config_files.should ==
        [ "/some/path", ".googleplay_dev_scraper", ENV['HOME'] + "/.googleplay_dev_scraper"]
    end
  end
end
