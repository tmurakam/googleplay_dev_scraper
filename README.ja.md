開発者向け Google Play / Google Checkout Scraper
================================================

はじめに
========

このツールは、Google Play デベロッパーコンソール、
および Google Checkout で提供される販売者向けの売上
レポート CSV ファイルを自動でダウンロードするための
ツールです。

Google Play デベロッパーコンソールからは以下のものを
ダウンロードできます。

* Google Play のデベロッパーコンソールで提供される販売レポート、予想販売レポート
* Google Wallet で提供されるオーダーリスト

売上の集計をするなり、経理システムにぶち込むなり、お好きに
どうぞ。


必要システム
============

以下のものが必要です。

* Ruby 1.9.3以上
* RubyGems

以下のようにしてインストールします。

    $ gem install googleplay_scraper


設定
====

設定ファイルを ~/.googleplay_scraper に YAML フォーマットで作成してください。
以下にサンプルを示します。

Google Play メールアドレスとパスワード、デベロッパIDを設定してください。
(素のパスワードを設定するのでアクセス権には注意)

デベロッパID は、developer console にログインした後の URL 末尾の
dev_acc=... の数字です。

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

なお、設定値はコマンドラインで与えることもできます。詳細は
--help オプションで確認してください。


使い方
======

売上レポート取得
----------------

2011年10月の売上を取得する場合は以下のようにします。
結果は標準出力に出力されます。

    $ googleplay_scraper sales 2011 10

また推定売上レポートもダウンロードできます。

    $ googleplay_scraper estimated 2011 10


オーダー一覧取得
----------------

オーダーの一覧を取得します。
開始日と終了日を指定します。時刻は日本時間で指定。

    $ googleplay_scraper orders "2011-08-01 00:00:00" "2011-09-30 23:59:59"


アプリケーション統計情報取得
----------------------------

Developer Console の統計情報 CSV エクスポートと同じものを得ます。
対象となるアプリのパッケージ名と、開始日/終了日を指定してください。

    $ googleplay_scraper appstats your.package.name 20120101 20120630 > stat.zip

ZIP ファイルが標準出力に出力されるので、リダイレクトでファイルに
落としてください。


API の利用
==========

例:

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
puts scraper.get_order_list(DateTime.parse("2012-11-01"), DateTime.parse("2012-11-30"))
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
