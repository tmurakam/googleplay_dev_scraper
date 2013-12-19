# -*- coding: utf-8 -*-
require 'spec_helper'

describe GooglePlayDevScraper::ApplicationStatistics do
  before do
    GooglePlayDevScraper.config(
      email: 'john@example.com',
      password: 'p@55w0rd',
      dev_acc: '1234567890'
    )
  end

  let(:package_name) { 'com.example.hello' }

  describe '.fetch' do
    subject { GooglePlayDevScraper::ApplicationStatistics.fetch(package_name) }
  end

  after { GooglePlayDevScraper.reset! }
end
