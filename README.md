Android Market / Google Checkout Scraper
========================================

はじめに
========

このツールは、Android Market および Google Checkout で提供
される販売者向けの売上レポート CSV ファイルを自動でダウン
ロードするためのツールです。

ダウンロードできるのは以下の２通りです。

* Android Market のデベロッパーコンソールで提供される販売レポート
* Google Checkout で提供される注文リスト

売上の集計をするなり、経理システムにぶち込むなり、お好きに
どうぞ。

必要システム
============

以下のものが必要です。

* Ruby 1.8.7以上 or 1.9.2以上
* RubyGems
* Mechanize 1.0.0

Mechanize は以下のようにインストールしてください。

 $ gem install mechanize -v 1.0.0

'11/12/12 現在、Mechanize の最新版は 2.0.1 ですが、このバージョン
では正常に動作しないので、1.0.0 が必要です。

設定とか
========

secrets.rb.sample を secrets.rb にコピーし、Android Market に
ログインするときのメールアドレスとパスワードを設定してください。
(素のパスワードを設定するのでアクセス権には注意)


使い方
======

売上レポートの取得 get-sales-report.rb を使います。
例えば 2011年10月の売上を取得する場合は以下のようにします。

  $ ./get-sales-report.rb 2011 10

オーダー一覧取得は get-orders.rb を使います。こちらは開始日時と
終了日時を指定します。時刻は日本時間で指定。

  $ ./get-orders.rb 2011-08-01T:00:00:00 2011-09-30T23:59:59


内部動作とか
============

Mechanize を使って Web サイトに自動アクセスし、フォームを叩いて
CSV を入手するだけです。ソース見れば何やってるかはわかる。


ライセンス
==========

Public domain 扱いとします。


免責事項
========

* 無保証です。
* Google 側のサイトの作りが変わったら当然動作しなくなります。

---
'11/12/12
Takuya Murakami <tmurakam at tmurakam.org>
