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

    $ gem install googleplay_dev_scraper

Configuration
=============

Create configuration file at ~/.googleplay_dev_scraper,
or ./.googleplay_dev_scraper in YAML format.

```yaml
# GooglePlay scraper config file sample (YAML format)
#
# Place this content to your ~/.googleplay_dev_scraper or
# ./.googleplay_dev_scraper.
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

    $ googleplay_dev_scraper sales 2011 10

Or you can download estimated report too:

    $ googleplay_dev_scraper estimated 2011 10 > report.zip

Note: Estimated report is compressed in zip file.

Get order report
----------------

To download order report, specify start and end time as:

    $ googleplay_dev_scraper orders "2011-08-01 00:00:00" "2011-09-30 23:59:59"

Get application statistics
--------------------------

Export application statistics in CSV format.
Specify application package name and start/end date.

    $ googleplay_dev_scraper appstats your.package.name 20120101 20120630 > stat.zip

Note: You must redirect output to zip file!

API usage
=========

Example:

```ruby
require 'googleplay_dev_scraper'

scraper = GooglePlayDevScraper::Scraper.new

# set config (Note: config file is not read via API access)
scraper.config.set_options({
  email: "foo@example.com"
  password: "YOUR_PASSWORD"
  dev_acc: "1234567890"
})

# get sales report / estimated sales report
puts scraper.get_sales_report(2012, 11)
puts scraper.get_estimated_sales_report(2012, 12)

# get orders
puts scraper.get_order_list(
  DateTime.parse("2012-11-01 00:00:00"), DateTime.parse("2012-11-30 23:59:59")
)

# get application statistics
#   available dimensions :
#     overall os_version device country language app_version carrier
#     gcm_message_status gcm_response_code crash_details anr_details
#
#    (use 'device' dimension may returns huge data set. be careful!) 
#
#   available metrics :
#     current_device_installs daily_device_installs daily_device_uninstalls
#     daily_device_upgrades current_user_installs total_user_installs
#     daily_user_installs daily_user_uninstalls daily_avg_rating total_avg_rating
#     gcm_messages gcm_registrations daily_crashes daily_anrs

stats = GooglePlayDevScraper::ApplicationStatistics.fetch(
  'com.example.helloworld',
  dimensions: %w(os_version country),
  metrics: %w(total_user_installs current_device_installs)
  start_date: Date.new(2013, 12, 5),
  end_date: Date.new(2013, 12, 6)
)

# stats is array of "GooglePlayDevScraper::ApplicationStatistics" class
stats[0].date
# => 2013-12-05

stats[0].dimension
# => :os_version

stats[0].field_name
# => current_device_installs

stats[0].entries
# => {"Android 2.3" => 1234, "Android 2.2" => 321 ....}

# to find object, 'select_by' and 'find_by' may help you.

stats.select_by(date: Date.new(2013, 12, 6), dimension: :os_version)
# =>
# [
#   #<GooglePlayDevScraper::ApplicationStatistics, @date=#<Date: 2013-12-06> .. >,
#   #<GooglePlayDevScraper::ApplicationStatistics, @date=#<Date: 2013-12-06> .. >,
#   .. 
# ]

stats.find_by(date: Date.new(2013, 12, 6), dimension: :os_version)
# => #<GooglePlayDevScraper::ApplicationStatistics .. >
# ( 'find_by' method always returns only one object which matches first )


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
