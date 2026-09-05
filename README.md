LightSpeedC
===========

> 📅 作成: 2026-08-27 / 更新: 2026-08-29

LightSpeedC の GitHub Pages リポジトリです。

## 公開URL

- https://lightspeedc.com/ — カスタムドメイン
- https://lightspeedc.github.io/ — 上記へリダイレクトされます

## 他のリポジトリの GitHub Pages も同じドメインで公開される

このリポジトリはユーザーページ（`<ユーザー名>.github.io`）にあたり、カスタムドメイン
`lightspeedc.com` を設定しています。GitHub の仕様により、同じアカウントの他のリポジトリで
GitHub Pages を有効にすると、そのリポジトリのページも自動的に
`https://lightspeedc.com/<リポジトリ名>/` で公開されます。

つまり `lightspeedc.com` のURL空間は、このリポジトリの `docs/` だけで完結していません。
リポジトリごとの Pages が同じドメインの下に並びます。

| URL | 配信元 |
|-----|--------|
| https://lightspeedc.com/ | このリポジトリの `docs/` |
| https://lightspeedc.com/20260822-powershell-pwsh-learn/ | リポジトリ `20260822-powershell-pwsh-learn` |
| https://lightspeedc.com/20260824-dos-command-learn/ | リポジトリ `20260824-dos-command-learn` |
| https://lightspeedc.com/20260824-node-deno-bun-compare/ | リポジトリ `20260824-node-deno-bun-compare` |
| https://lightspeedc.com/20260824-local-llm-llama-cp/ | リポジトリ `20260824-local-llm-llama-cp` |
| https://lightspeedc.com/20260828-typescript-learn/ | リポジトリ `20260828-typescript-learn` |

新しいリポジトリで Pages を有効にすれば、設定を追加しなくてもリポジトリ名の
パスで公開されます。

> [!WARNING]
> **`docs/` の直下に置くフォルダ名は、リポジトリ名と重複させないこと**。
> 同じURLを取り合うことになり、どちらが配信されているのか分からなくなります。
>
> 例えば `docs/20260824-dos-command-learn/` というフォルダを作ると、
> https://lightspeedc.com/20260824-dos-command-learn/ が
> このリポジトリの `docs/` 配下を指すのか、リポジトリ
> `20260824-dos-command-learn` の Pages を指すのかが曖昧になります。
>
> 逆方向も同じです。`docs/` に既にあるフォルダ名
> （`css` `js` `mui` `mdl` `mithril` `react` `public` `web-app-intro`）と
> 同じ名前のリポジトリを新しく作って Pages を有効にすると、同様に競合します。

## フォルダ構成

公開されるファイルは `docs/` 配下にまとめています。GitHub Pages の公開ソースを
`master` ブランチの `/docs` フォルダに設定しているため、`docs/` の中身がそのまま
サイトのルートとして配信されます。`docs/` の外にあるファイルは公開されません。

```
docs/                公開されるファイル（サイトのルート）
  index.html         トップページ
  index-old.html     刷新前のトップページ（履歴として保存）
  index.json         index-old.html が読み込むリンク一覧
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

notes/               公開されない記録
  status/            構成と作業状況の記録

app.js               ローカル確認用の静的サーバー（docs/ を配信する）
package.json         ローカル確認用の依存定義
run.cmd              ローカル確認の起動スクリプト
README.md            この文書
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
