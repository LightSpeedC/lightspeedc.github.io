# lightspeedc.com ローカルルール

このリポジトリでだけ通る決めごと

> 📅 作成: 2026-09-09 / 更新: 2026-09-09

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
