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

  describe '.fetch' do
    subject { GooglePlayDevScraper::ApplicationStatistics.fetch }
  end

  after { GooglePlayDevScraper.reset! }
end
