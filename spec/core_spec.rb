# -*- coding: utf-8 -*-
require 'spec_helper'

describe GooglePlayDevScraper do
  describe '.config' do
    let(:email) { 'john@example.com' }
    let(:password) { 'p@55w0rd' }
    let(:dev_acc) { '1234567890' }
    let(:proxy_host) { 'proxy.example.com' }
    let(:proxy_port) { 8080 }

    context 'without options' do
      subject { GooglePlayDevScraper.config }
      it { should be_an_instance_of GooglePlayDevScraper::ScraperConfig }
      %w(email password dev_acc proxy_host proxy_port).each do |attr|
        its(attr.to_sym) { should be_nil }
      end
    end

    context 'with args' do
      let(:params) do
        {
          email: email,
          password: password,
          dev_acc: dev_acc,
          proxy_host: proxy_host,
          proxy_port: proxy_port
        }
      end
      subject { GooglePlayDevScraper.config(params) }
      it { should be_an_instance_of GooglePlayDevScraper::ScraperConfig }
      its(:email) { should eq email }
      its(:password) { should eq password }
      its(:dev_acc) { should eq dev_acc }
      its(:proxy_host) { should eq proxy_host }
      its(:proxy_port) { should eq proxy_port }
    end
  end

  after { GooglePlayDevScraper.reset! }
end
