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
では正常に動作しません。そのため 1.0.0 が必要です。


設定とか
========

secrets.rb.sample を secrets.rb にコピーし、Android Market に
ログインするときのメールアドレスとパスワードを設定してください。
(素のパスワードを設定するのでアクセス権には注意)


使い方
======

売上レポートの取得には get-sales-report.rb を使います。
例えば 2011年10月の売上を取得する場合は以下のようにします。
結果は標準出力に出力されます。

    $ ./get-sales-report.rb 2011 10

オーダー一覧取得は get-orders.rb を使います。こちらは開始日時と
終了日時を指定します。時刻は日本時間で指定。

    $ ./get-orders.rb 2011-08-01T:00:00:00 2011-09-30T23:59:59

なお、get-orders.rb には第３引数として以下のいずれかの条件を指定
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


内部動作とか
============

Mechanize を使って Web サイトに自動アクセスし、フォームを叩いて
CSV を入手するだけです。

本体は android_checkout_scraper.rb です。ソース見れば何やってる
かはわかると思います。Rails アプリの中で使うとか、お好きにどうぞ。


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
'11/12/12
Takuya Murakami, E-mail: tmurakam at tmurakam.org
