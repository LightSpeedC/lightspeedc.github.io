# lightspeedc.com ローカルルール

このリポジトリでだけ通る決めごと

> 📅 作成: 2026-09-09 / 更新: 2026-10-07

## 1. ブランチは2本で運用する

適用条件: このリポジトリで作業するとき。

- `develop` と `master` の2本。`release` は使わない
- `master` が GitHub Pages の公開ソース（`master` ブランチ / `/docs`）

## 2. トップページへの掲載

適用条件: ai-chat-lite で他プロジェクトから掲載を依頼されたとき、および `docs/index.html` の資料一覧を増減するとき。

### 依頼の受け付け

- 依頼を受けたら、利用者の確認を待たずに `docs/index.html` へ反映する
- 説明は依頼元リポジトリの `description` を転記する。自分で書き起こさない
- **commit ・ push は別**。掲載の反映までを自動で進める範囲とし、公開は指示を待つ
- 返信は公開が済んでから送る

### 並び

- 1章・2章とも、新しいものを上に置く
- 既存の並びは動かさない。過去に追加した分を日付順に並べ直すことはしない
- 関連する資料が続くときは、ひとまとまりのまま扱う（ai-chat 系3件）

### 資料見出し（h2）の虹色

- 章（h1）とは別に、資料見出し（h2）にも 280°→0° の虹色を割り当てる
- **刻みは「最も項目数が多い章の等分」で固定**（`280 ÷ (最多件数 - 1)`）。項目の少ない章は途中で止まる
- 色相は `.dc01`〜 のクラスに `--dh` として持たせ、`section h2 a`（資料へのリンクのバッジ）が `hsl(var(--dh, 220), ...)` で参照する
- **資料を増減したら刻みを計算し直し、全章の `.dcNN` を振り直す**

## 3. html2md では status を除外する

適用条件: `html2md` を走らせるとき。

- **`--exclude status.html` を必ず付ける**
- `notes/status/status.html` は HTML だけで運用する。Markdown 版は持たない

```
html2md --root <プロジェクトフォルダ> --exclude status.html
```

> [!NOTE]
> **付け忘れても成功して終わる。** `notes/status/status.md` と、インライン SVG を切り出した `notes/status/images/status-fig01.svg` が黙って増える。検査も「指摘なし」で通る。

## 4. master へのマージ・push は publish-master.ps1 を使う

適用条件: `develop` から `master` へマージして公開するとき。

- 手作業でコマンドを並べない。`tools/80_ops/publish-master.ps1` を使う
- マージメッセージは事前にファイルへ書き、`-MergeMessageFile` に渡す
- タグ名は共通ルール「タグ名」の形（`yyyy/mm/dd_master` 等）に従う
- **各ステップの成否を確認してから次に進む。** 失敗したらそこで止まる。改行区切りでコマンドを並べて失敗を見逃す事故を防ぐ

```
tools/80_ops/publish-master.ps1 `
  -MergeMessageFile tmp/merge-message.txt `
  -TagName "2026/09/23_master-02" `
  -TagMessage "AGENTS.md移行・sleepルール・cron待受けルールを反映"
```

## 5. ビルド確認は実時間の sleep で待つ

適用条件: `master` を push したあと、Pages のビルドを確認するとき。

- 待ち方・手動依頼・流し直しは、共通ルール「GitHub Pages 公開ルール」＞「push のあとに公開を確かめる」に従う
- **上書き: 確かめるのは `pages/builds/latest` ではなく、Actions の run。** Pages API の status は、queued（ランナー待ち）も実行中も `building` と返り、区別がつかないため。見るのは `gh run list` の `headSha` が、push した commit と一致するか
- 自動で積まれる回と積まれない回が不規則に出る（i260917-01）。待ち時間は <strong>5分（300秒）</strong>で、公開の確認は「該当 commit の run が `success`」まで取る
- **push した時刻・確認した時刻・手動で依頼した時刻を、いずれも「月/日 時:分」（JST）で表示する。** 実際にどれだけ待ったかを利用者が見て確かめられるようにする

```
date "+push: %m/%d %H:%M"
sleep 300 && date "+確認: %m/%d %H:%M（5分待った）" && gh run list --repo LightSpeedC/lightspeedc.github.io --limit 1 --json databaseId,headSha,createdAt
```

該当 commit の run が現れなければ、手動で依頼する。

```
date "+手動ビルド依頼: %m/%d %H:%M" && gh api -X POST repos/LightSpeedC/lightspeedc.github.io/pages/builds --jq ".status"
```

> [!NOTE]
> **run が queued のまま滞留したときは、手動の再リクエストでは直らない。** 走っているジョブを cancel して新しく積むだけで、待ち行列の先頭には入らない。Actions の画面で滞留ジョブを消してから積み直す。公開されている中身は旧版のまま正しいので、URL を叩いても気づけない。

## 6. 4時間ごと（8〜24時）に待受けを cron で回す

適用条件: このリポジトリで ai-chat-lite の待受けを運用するとき。

- **4時間おき、8・12・16・20・24（0）時に `CronCreate` で仕込む。** 式は `43 0,8,12,16,20 * * *`。対象ルームは `public`
- 起きるたびに、起きた時刻を <strong>「月/日 時:分」（JST）</strong>で表示する
- **受けた発言のうち当リポジトリに関係するものは、概要を表示する。** 関係の有無・報告の要不要の判断は共通ルール「ai-chat-lite（AI 間チャット）の利用」に従う
- 張り直し・カウント・止めてよい範囲も同じ共通ルールに従う。ここで決めるのは頻度と、起きたときに時刻・概要を出すことだけ
- **待受けも cron も、セッションを閉じれば消える。cron は最大7日で失効する。** 開き直したら、共通ルール「セッションを開き直したとき」に従い、指示を待たず両方を張り直す（待受けは `waiters` で数えてから、cron はこの章の式で作り直す）
