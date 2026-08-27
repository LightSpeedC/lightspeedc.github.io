LightSpeedC
===========

LightSpeedC の GitHub Pages リポジトリです。

## 公開URL

- https://lightspeedc.com/ — カスタムドメイン
- https://lightspeedc.github.io/ — 上記へリダイレクトされます

## フォルダ構成

公開されるファイルは `docs/` 配下にまとめています。GitHub Pages の公開ソースを
`master` ブランチの `/docs` フォルダに設定しているため、`docs/` の中身がそのまま
サイトのルートとして配信されます。`docs/` の外にあるファイルは公開されません。

```
docs/                公開されるファイル（サイトのルート）
  index.html         トップページ
  index.json         トップページのリンク一覧
  ie.html            Internet Explorer 向けのページ
  CNAME              カスタムドメインの設定
  favicon.ico        ファビコン
  .nojekyll          Jekyll によるビルドを無効化（ファイルをそのまま配信する）
  css/               共通のスタイル
  js/                共通のスクリプト
  mui/               MUI CSS のサンプル
  mdl/               Material Design Lite のサンプル
  mithril/           Mithril.js のサンプル
  react/             React のサンプル
  public/            Firebase のサンプル
  web-app-intro/     Web アプリ入門のサンプル

app.js               ローカル確認用の静的サーバー（docs/ を配信する）
package.json         ローカル確認用の依存定義
run.cmd              ローカル確認の起動スクリプト
```

## ローカルでの確認

`run.cmd` を実行すると、依存パッケージのインストール後に
http://localhost:3001/ でサイトが開きます。

```
run.cmd
```

ポートを変えたい場合は、ポート番号を引数に渡して起動します。

```
node app 8080
```

## リポジトリ

https://github.com/LightSpeedC/lightspeedc.github.io#readme
