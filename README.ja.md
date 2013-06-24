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

* 販売レポート
* 予想販売レポート
* アプリ統計情報

Google Checkout からは以下のものをダウンロードできます。
ただし、Google Wallet Merchant Center にアカウントが移行
した場合はこれらはダウンロードできません。

* 注文リスト
* 支払概要

売上の集計をするなり、経理システムにぶち込むなり、お好きに
どうぞ。

この他、自動で発送ボタンを押す機能もあります。


必要システム
============

以下のものが必要です。

* Ruby 1.8.7以上 or 1.9.2以上
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
開始日時と終了日時を指定します。時刻は日本時間で指定。

    $ googleplay_scraper orders 2011-08-01T:00:00:00 2011-09-30T23:59:59

--details オプションを付与すると詳細な CSV データを出力します。

    $ googleplay_scraper --details orders 2011-08-01T:00:00:00 2011-09-30T23:59:59

なお、第4引数として以下のいずれかの条件を指定
できます。省略時は CHARGED が指定されたものとして扱います。

* ALL : すべて
* CANCELLED : ユーザーによりキャンセルされました
* CANCELLED_BY_GOOGLE : Google によりキャンセルされました
* CHARGEABLE: 請求可能
* CHARGED : 請求済み
* CHARGING : 請求中
* PAYMENT_DECLINED : 支払いの不承認
* REVIEWING : 確認中

なお、オーダー一覧は最大で 500件までしか取得できません(サイトには
そう書いてある)。したがって、これより多くのデータを取得したい場合は
開始日時と終了日時を狭めて取得してください。


支払い概要取得
--------------

Google checkout の支払概要を取得します。
こちらは開始日と終了日を指定します。

    $ googleplay_scraper payouts 2011-11-01 2011-12-01

第4引数には以下の引数を指定できます。省略時は PAYOUT_REPORT です。

* PAYOUT_REPORT : 支払いの詳細
* TRANSACTION_DETAIL_REPORT : トランザクション


アプリケーション統計情報取得
----------------------------

Developer Console の統計情報 CSV エクスポートと同じものを得ます。
対象となるアプリのパッケージ名と、開始日/終了日を指定してください。

    $ googleplay_scraper appstats your.package.name 20120101 20120630 > stat.zip

ZIP ファイルが標準出力に出力されるので、リダイレクトでファイルに
落としてください。


発送ボタン自動処理
------------------

注文の受信トレイにある全ての「発送」ボタンを自動で押す機能です。
使い方は以下のとおり。

    $ googleplay_scraper autodeliver

「アーカイブ」も全部押したい場合は --auto オプションをつけてください。

なお、発送ボタンが押されるのは注文の受信トレイの１ページ目に
あるオーダーだけです。2ページ目以降のものは押されません。

そもそもなんで発送ボタンなるものがあるのか不明ですが、、、


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
puts scraper.get_order_list("2012-11-01T00:00:00", "2012-11-30T23:59:59", "CHARGED", true)

# get payout report
puts scraper.get_payouts("2012-11-01", "2012-12-1", "PAYOUT_REPORT")
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

* Google さん、Android 向けの Google Checkout API 解放してくれるとすごく嬉しいのですが、、、

---
'13/6/24
Takuya Murakami, E-mail: tmurakam at tmurakam.org
