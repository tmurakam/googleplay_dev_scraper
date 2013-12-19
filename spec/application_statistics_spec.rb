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
    context 'with single file' do
      let(:csv) { File.read(File.dirname(__FILE__) + '/com.example.hello_app_version_installs.csv')}

      let(:stub_statistics_download_request) do
        stub_request(:get, 'https://play.google.com/apps/publish/statistics/download').with(
          query: {
            dim: 'app_version',
            sd: '20131205',
            ed: '20131206',
            met: 'current_device_installs,total_user_installs',
            package: 'com.example.hello'
          }
        ).to_return(
          body: csv,
          headers: {
            'Content-Type' => 'text/csv'
          }
        )
      end

      let(:options) do
        {
          dimensions: %w(app_version),
          metrics: %w(current_device_installs total_user_installs),
          start_date: Date.new(2013, 12, 5),
          end_date: Date.new(2013, 12, 6)
        }
      end

      before { stub_statistics_download_request }
      let(:stats) { GooglePlayDevScraper::ApplicationStatistics.fetch(package_name, options) }
      let(:target_stat) { stats.find_by(date: Date.new(2013, 12, 6), field_name: :current_device_installs) }
      subject { stats }
      it { should be_an_instance_of GooglePlayDevScraper::ApplicationStatisticsCollection }
      it { target_stat.entries['1.0'].should eq 120 }
      it { target_stat.dimension.should eq :app_version }
    end

    context 'with multiple file' do
      let(:zip) { File.read(File.dirname(__FILE__) + '/com.example.hello.zip')}

      let(:stub_statistics_download_request) do
        stub_request(:get, 'https://play.google.com/apps/publish/statistics/download').with(
          query: {
            dim: 'overall,language,country',
            sd: '20131205',
            ed: '20131206',
            met: 'current_device_installs,total_user_installs',
            package: 'com.example.hello'
          }
        ).to_return(
          body: zip,
          headers: {
            'Content-Type' => 'application/zip'
          }
        )
      end

      let(:options) do
        {
          dimensions: %w(overall language country),
          metrics: %w(current_device_installs total_user_installs),
          start_date: Date.new(2013, 12, 5),
          end_date: Date.new(2013, 12, 6)
        }
      end

      before { stub_statistics_download_request }
      let(:stats) { GooglePlayDevScraper::ApplicationStatistics.fetch(package_name, options) }
      let(:target_stat) { stats.find_by(date: Date.new(2013, 12, 6), field_name: :current_device_installs, dimension: :language) }
      subject { stats }
      it { should be_an_instance_of GooglePlayDevScraper::ApplicationStatisticsCollection }
      it { target_stat.entries['ja_JP'].should eq 100 }
    end
  end

  after { GooglePlayDevScraper.reset! }
end
