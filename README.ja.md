Android 開発者向け Google Play / Google Wallet Scraper
======================================================

はじめに
========

このツールは、Google Play デベロッパーコンソール、
および Google Wallet で提供される販売者向けの売上
レポートなどの CSV ファイルを自動でダウンロードするための
ツールです。

Google Play デベロッパーコンソールからは以下のものをダウンロードできます。

* 販売レポート
* 予想販売レポート
* アプリ統計情報

Google Wallet Merchant Center からは以下のものをダウンロードできます。

* オーダー一覧

売上の集計をするなり、経理システムにぶち込むなり、お好きにどうぞ。


必要システム
============

以下のものが必要です。

* Ruby 1.9.3以上
* RubyGems

以下のようにしてインストールします。

    $ gem install googleplay_dev_scraper


設定
====

設定ファイルを ~/.googleplay_dev_scraper に YAML フォーマットで作成してください。
以下にサンプルを示します。

Google Play メールアドレスとパスワード、デベロッパIDを設定してください。
(素のパスワードを設定するのでアクセス権には注意)

デベロッパID は、developer console にログインした後の URL 末尾の
dev_acc=... の数字です。

```yaml
# GooglePlay dev scraper config file sample (YAML format)
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

なお、設定値はコマンドラインで与えることもできます。詳細は
--help オプションで確認してください。


使い方
======

売上レポート取得
----------------

2011年10月の売上を取得する場合は以下のようにします。
結果は標準出力に出力されます。

    $ googleplay_dev_scraper sales 2011 10

また推定売上レポートもダウンロードできます。

    $ googleplay_dev_scraper estimated 2011 10 > report.zip

注意: 推定売上レポートは ZIP ファイルとなっています。


オーダー一覧取得
----------------

オーダーの一覧を取得します。
開始日と終了日を指定します。時刻は日本時間で指定。

    $ googleplay_dev_scraper orders "2011-08-01 00:00:00" "2011-09-30 23:59:59"


アプリケーション統計情報取得
----------------------------

Developer Console の統計情報 CSV エクスポートと同じものを得ます。
対象となるアプリのパッケージ名と、開始日/終了日を指定してください。

    $ googleplay_dev_scraper appstats your.package.name 20120101 20120630 > stat.zip

ZIP ファイルが標準出力に出力されるので、リダイレクトでファイルに
落としてください。


API の利用
==========

例:

```ruby
require 'googleplay_dev_scraper'

scraper = GooglePlayDevScraper::Scraper.new

# 設定 (config ファイルはモジュールを用いた場合には読み込まれません)
GooglePlayDevScraper.config(
  email: "foo@example.com"
  password: "YOUR_PASSWORD"
  dev_acc: "1234567890"
)

# 売上レポート取得
puts scraper.get_sales_report(2012, 11)
puts scraper.get_estimated_sales_report(2012, 12)

# オーダー一覧取得
puts scraper.get_order_list(DateTime.parse("2012-11-01"), DateTime.parse("2012-11-30"))

# アプリケーション統計情報取得
#   dimensions オプションに利用可能なパラメータ:
#     overall os_version device country language app_version carrier
#     gcm_message_status gcm_response_code crash_details anr_details
#
#    ('device' dimension をセットすると、返却されるデータがとても大きくなります!!) 
#
#   metrics オプションに利用可能なパラメータ:
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

# stats は "GooglePlayDevScraper::ApplicationStatistics" クラスの配列です 
stats[0].date
# => 2013-12-05

stats[0].dimension
# => :os_version

stats[0].field_name
# => current_device_installs

stats[0].entries
# => {"Android 2.3" => 1234, "Android 2.2" => 321 ....}

# 'select_by' と 'find_by' メソッドを用意しました。条件を指定して探せます。

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

内部動作とか
============

Mechanize を使って Web サイトに自動アクセスし、フォームを叩いて
CSV を入手するだけです。

本体は scraper.rb です。ソース見れば何やってるかはわかると思います。
Rails アプリの中で使うとか、お好きにどうぞ。


ライセンス
==========

Public domain 扱いとします。


免責事項
========

* 無保証です。
* Google 側のサイトの作りが変わったら当然動作しなくなります。
* Google から怒られても責任は取りません。
* 動かなくても文句言わない。自分で直すように。
* 直したら修正を送るなり pull request するなりしてくれると嬉しい。


ひとりごと
==========

* Google さん、Android 向けの Google Wallet API (オーダー一覧とか)解放してくれるとすごく嬉しいのですが、、、

---
'13/7/18
Takuya Murakami, E-mail: tmurakam at tmurakam.org
