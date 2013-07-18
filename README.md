Google Play / Google Wallet Scraper for Android Developers
==========================================================

Introduction
============

This tool is designed to download CSV report files from
Google Play developer console and google wallet.

It can download following CSV files from Google Play
developer console

* Sales report (monthly report)
* Estimateds sales report
* Application statistics

It can download following CSV files from Google Wallet.

* Order list (almost realtime)

You don't need any merchant key, because this tool scrapes
google play / wallet website.

Requirements/Installation
=========================

* Ruby >=1.9.3
* RubyGems

To install:

    $ gem install googleplay_scraper

Configuration
=============

Create configuration file at ~/.googleplay_scraper,
or ./.googleplay_scraper in YAML format.

```
# GooglePlay scraper config file sample (YAML format)
#
# Place this content to your ~/.googleplay_scraper or
# ./.googleplay_scraper.
#
# WARNING: This file contains password, be careful
# of file permission.

# Your E-mail address to login google play
email: foo@example.com

# Your password to login google play
password: "Your Password"

# Developer account ID
# You can find your developer account ID in the URL 
# after 'dev_acc=...' when login the developer console.
dev_acc: "12345678901234567890"

# Proxy host and port number (if needed) 
#proxy_host: proxy.example.com
#proxy_port: 8080
```

You can specify configuration parameters with command line
options. See details with --help option.

How to use
==========

Get sales report
----------------

To download sales report for October 2011:

    $ googleplay_scraper sales 2011 10

Or you can download estimated report too:

    $ googleplay_scraper estimated 2011 10

Get order report
----------------

To download order report, specify start and end time as:

    $ googleplay_scraper orders "2011-08-01 00:00:00" "2011-09-30 23:59:59"

Get application statistics
--------------------------

Export application statistics in CSV format.
Specify application package name and start/end date.

    $ googleplay_scraper appstats your.package.name 20120101 20120630 > stat.zip

Note: You must redirect output to zip file!

API usage
=========

Example:

```
require 'googleplay_scraper'

scraper = GooglePlayScraper::Scraper.new

# set config (Note: config file is not read via API access)
scraper.config.email = "foo@example.com"
scraper.config.password = "YOUR_PASSWORD"
scraper.config.dev_acc = "1234567890"

# get sales report / estimated sales report
puts scraper.get_sales_report(2012, 11)
puts scraper.get_estimated_sales_report(2012, 12)

# get orders
puts scraper.get_order_list(DateTime.parse("2012-11-01 00:00:00", DateTime.parse("2012-11-30T23:59:59"))
```

License
=======

Public domain


Disclaimer
==========

* NO WARRANTY

---
'13/7/18
Takuya Murakami, E-mail: tmurakam at tmurakam.org
