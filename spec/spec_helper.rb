# -*- encoding: utf-8 -*-
require 'rubygems'
require 'googleplay_scraper'

class ScraperMock < GooglePlayScraper::Scraper
  attr_reader :accessed_url

  def initialize
    super
    @agent = MechanizeMock.new
  end

  def try_get(url)
    setup
    @accessed_url = url
  end
end

class MechanizeMock < Mechanize
  def initialize
    super
    @page_mock = PageMock.new
  end

  def page
    @page_mock
  end
end

class PageMock
  def body
    return "BODY"
  end
end
