Google Play / Google Checkout Scraper for Developers
====================================================

Introduction
============

This tool is designed to download CSV report files from
Google Play developer console and google checkout.

It can download following CSV files from Google Play 
developer console

* Sales report (monthly report)
* Estimateds sales report

It can download following CSV files from Google Checkout.
(Note: You can't do it if your account has been migrated
to google wallet.)

* Order list (almost realtime)
* Payout report

Also, it can press all "ship" buttons on google checkout.

You don't need any merchant key, because this tool scrapes
google checkout website.

Requirements/Installation
=========================

* Ruby >=1.8.7 or >= 1.9.2
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

    $ googleplay_scraper orders 2011-08-01T:00:00:00 2011-09-30T23:59:59

You can use --details option to show expanded csv format.

    $ googleplay_scraper --details orders 2011-08-01T:00:00:00 2011-09-30T23:59:59

You can specify 4th argument from:

* ALL
* CANCELLED
* CANCELLED_BY_GOOGLE
* CHARGEABLE
* CHARGED
* CHARGING 
* PAYMENT_DECLINED
* REVIEWING


Get payout report
-----------------

To download payout report, specify start / end date as:

    $ googleplay_scraper payouts 2011-11-01 2011-12-01

You can specify 4th argument from:

* PAYOUT_REPORT
* TRANSACTION_DETAIL_REPORT


Get application satistics
-------------------------

Export application statistics in CSV format.
Specify application package name and start/end date.

    $ googleplay_scraper appstats your.package.name 20120101 20120630 > stat.zip

Note: You must redirect output to zip file!


Auto press ship buttons
-----------------------

Press all "ship" buttons on Orders - Inbox page of google checkout:

    $ googleplay_scraper autodeliver

To archive all orders:

    $ googleplay_scraper --auto autodeliver

Note: This can press buttons ONLY on first page. If you have too 
many orders on first page, you must archive them manually or
use '--auto' option.

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
puts scraper.get_order_list("2012-11-01T00:00:00", "2012-11-30T23:59:59", "CHARGED", true)

# get payout report
puts scraper.get_payouts("2012-11-01", "2012-12-1", "PAYOUT_REPORT")
```

License
=======

Public domain


Disclaimer
==========

* NO WARRANTY

---
'13/6/24
Takuya Murakami, E-mail: tmurakam at tmurakam.org
