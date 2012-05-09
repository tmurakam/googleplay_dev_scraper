Android Market / Google Checkout Scraper
========================================

Introduction
============

This tool is designed to download CSV files for android market 
from google checkout site automatically.

It can download following CSV files.

* Sales report (monthly)
* Order list
* Payout report

Also, it can press all "ship" buttons on google checkout.

You don't need any merchant key, because this tool scrapes
google checkout website.

Requirements
============

* Ruby >=1.8.7 or >= 1.9.2
* RubyGems
* Mechanize 1.0.0

You need to install Mechanize as:

    $ gem install mechanize -v 1.0.0


Set up
======

Copy config.rb.sample to config.rb and edit it.

Copy secrets.rb.sample to secrets.rb, and set up your
mail address and password, and developer account id.

You can find your developer account id in the URL 
after 'dev_acc=...' when login the developer console.


How to use
==========

Get sales report
----------------

To download sales report for October 2011:

    $ ./get-sales-report.rb 2011 10

Or you can download estimated report too:

    $ ./get-estimated-sales-report.rb 2011 10

Get order report
----------------

To download order report, specify start and end time as:

    $ ./get-orders.rb 2011-08-01T:00:00:00 2011-09-30T23:59:59

You can use --details option to show expanded csv format.

You can specify 3rd argument from:

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

    $ ./get-payouts.rb 2011-11-01 2011-12-01

You can specify 3rd argument from:

* PAYOUT_REPORT
* TRANSACTION_DETAIL_REPORT

Auto press ship buttons
-----------------------

Press all "ship" buttons on Orders - Inbox page of google checkout:

    $ ./auto-deliver.rb

To archive all orders:

    $ ./auto-deliver.rb -a

Note: This can press buttons ONLY on first page. If you have too 
many orders on first page, you must archive them manually or
use '-a' option.

License
=======

Public domain


Disclaimer
==========

* NO WARRANTY

---
'11/12/12
Takuya Murakami, E-mail: tmurakam at tmurakam.org
