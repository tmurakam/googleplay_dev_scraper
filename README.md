Google Play / Google Checkout Scraper for Developers
====================================================

Introduction
============

This tool is designed to download CSV report files from
Google Play developer console and google checkout.

It can download following CSV files.

* Sales report (monthly report)
* Estimateds sales report
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

    $ gem install googleplay-scraper

Configuration
=============

Create configuration file with ~/.googleplay-scraper,
or ./.googleplay-scraper.

```
# GooglePlay scraper config file sample
#
# Place this content to your ~/.googleplay-scraper or
# ./.googleplay-scraper.
#
# Warning: This file contains password, be careful
# of file permission.

# Your E-mail address to login google play
$email_address = ""

# Your password to login google play
$password = ""

# Developer account ID
# You can find your developer account ID in the URL 
# after 'dev_acc=...' when login the developer console.
$dev_acc=""

# Proxy host and port number (if needed) 
#$proxy_host = nil
#$proxy_port = -1
```

How to use
==========

Get sales report
----------------

To download sales report for October 2011:

    $ googleplay-scraper sales 2011 10

Or you can download estimated report too:

    $ googleplay-scraper estimated 2011 10

Get order report
----------------

To download order report, specify start and end time as:

    $ googleplay-scraper orders 2011-08-01T:00:00:00 2011-09-30T23:59:59

You can use --details option to show expanded csv format.

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

    $ googleplay-scraper payouts 2011-11-01 2011-12-01

You can specify 3rd argument from:

* PAYOUT_REPORT
* TRANSACTION_DETAIL_REPORT


Get application satistics
-------------------------

Export application statistics in CSV format.
Specify application package name and start/end date.

    $ googleplay-scraper appstats your.package.name 20120101 20120630 > stat.zip

Note: You must redirect output to zip file!


Auto press ship buttons
-----------------------

Press all "ship" buttons on Orders - Inbox page of google checkout:

    $ googleplay-scraper autodeliver

To archive all orders:

    $ googleplay-scraper --auto autodeliver

Note: This can press buttons ONLY on first page. If you have too 
many orders on first page, you must archive them manually or
use '--auto' option.

License
=======

Public domain


Disclaimer
==========

* NO WARRANTY

---
'12/12/13
Takuya Murakami, E-mail: tmurakam at tmurakam.org
