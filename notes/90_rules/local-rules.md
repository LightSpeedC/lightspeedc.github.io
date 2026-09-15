# lightspeedc.com ローカルルール

このリポジトリでだけ通る決めごと

> 📅 作成: 2026-09-09 / 更新: 2026-09-13

## 1. 資料見出し（h2）にも虹色を割り当てる

適用条件: `docs/index.html` の資料一覧を増減するとき。

- 章（h1）とは別に、資料見出し（h2）にも 280°→0° の虹色を割り当てる
- **刻みは「最も項目数が多い章の等分」で固定**（`280 ÷ (最多件数 - 1)`）。項目の少ない章は途中で止まる
- 色相は `.dc01`〜 のクラスに `--dh` として持たせ、`section h2` が `hsl(var(--dh, 220), ...)` で参照する
- **資料を増減したら刻みを計算し直し、全章の `.dcNN` を振り直す**

## 2. html2md では status を除外する

適用条件: `html2md` を走らせるとき。

- **`--exclude status.html` を必ず付ける**
- `notes/status/status.html` は HTML だけで運用する。Markdown 版は持たない

```
html2md --root <プロジェクトフォルダ> --exclude status.html
```

> [!NOTE]
> **付け忘れても成功して終わる。** `notes/status/status.md` と、インライン SVG を切り出した `notes/status/images/status-fig01.svg` が黙って増える。検査も「指摘なし」で通る。

## 3. ブランチは2本で運用する

適用条件: このリポジトリで作業するとき。

- `develop` と `master` の2本。`release` は使わない
- `master` が GitHub Pages の公開ソース（`master` ブランチ / `/docs`）

## 4. Pages のビルドが queued で止まることがある

適用条件: `master` を push したあと。

- ビルドの完了は Pages API の status で見ない。queued（ランナー待ち）も実行中も building と返るため、区別がつかない
- 見るのは Actions 側
- 最新ビルドの commit が push したものと一致することも確かめる

```
gh run list --repo LightSpeedC/lightspeedc.github.io --limit 1
```

> [!NOTE]
> **手動の再リクエストでは直らない。** 走っているジョブを cancel して新しく積むだけで、待ち行列の先頭には入らない。滞留したときは Actions の画面で滞留ジョブを消してから積み直す。公開されている中身は旧版のまま正しいので、URL を叩いても気づけない。

## 5. 新しい資料は章の先頭に入れる

適用条件: `docs/index.html` の資料一覧に資料を足すとき。

- 1章・2章とも、新しいものを上に置く
- 既存の並びは動かさない。過去に追加した分を日付順に並べ直すことはしない
- 関連する資料が続くときは、ひとまとまりのまま扱う（ai-chat 系3件）
