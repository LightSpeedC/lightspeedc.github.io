# docs/index.html の2章の先頭に資料を1件足し、資料見出し（h2）の色相を振り直す
param(
	[Parameter(Mandatory)][string]$RepoName,
	[Parameter(Mandatory)][string]$Title,
	[Parameter(Mandatory)][string]$Description,
	[Parameter(Mandatory)][string]$CreatedDate,
	[Parameter(Mandatory)][string]$PublishedDate
)
$ErrorActionPreference = 'Stop'
$targetFile = Join-Path $PSScriptRoot '../../docs/index.html'
$htmlText = [System.IO.File]::ReadAllText($targetFile)
if ($htmlText.Contains("LightSpeedC/$RepoName")) { throw "既に載っている: $RepoName" }
$splitPos = $htmlText.IndexOf('<section class="ch02" id="ch02">')
if ($splitPos -lt 0) { throw 'ch02 が見つからない' }
$headPart = $htmlText.Substring(0, $splitPos)
$tailPart = $htmlText.Substring($splitPos)
# 2章の dcNN を 1 つずつ繰り下げる
$tailPart = [regex]::Replace($tailPart, '\bdc(\d{2})\b', { param($m) 'dc{0:D2}' -f ([int]$m.Groups[1].Value + 1) })
$ghIcon = [regex]::Match($htmlText, '<svg viewBox="0 0 16 16" aria-hidden="true"><path d="M8 0C3[^"]*"/></svg>').Value
if (-not $ghIcon) { throw 'GitHub アイコンが見つからない' }
$webIcon = '<svg viewBox="0 0 16 16" aria-hidden="true"><circle cx="8" cy="8" r="6.5"/><ellipse cx="8" cy="8" rx="3" ry="6.5"/><path d="M1.5 8h13"/></svg>'
$newItem = (@(
	"<h2 class=`"dc01`"><a href=`"./$RepoName/`">$Title</a></h2>",
	"`t`t<div class=`"item dc01`">",
	"`t`t`t<p class=`"desc`">$Description</p>",
	"`t`t`t<p class=`"links`">",
	"`t`t`t`t<a class=`"webbadge`" href=`"./$RepoName/`">${webIcon}公開Web</a>",
	"`t`t`t`t<a class=`"ghbadge`" href=`"https://github.com/LightSpeedC/$RepoName#readme`">${ghIcon}GitHub</a>",
	"`t`t`t`t<span class=`"pubdate`">📅 作成: $CreatedDate / 公開: $PublishedDate</span>",
	"`t`t`t</p>",
	"`t`t</div>",
	"",
	"`t`t<h2 class=`"dc02`">"
) -join "`n")
# 見出しには offline 等の別のクラスが付くことがある（公開を止めた資料）。後ろのクラスごと残して差し込む
$h2Pattern = [regex]::new('<h2 class="dc02([ "])')
if (-not $h2Pattern.IsMatch($tailPart)) { throw '2章の先頭の見出し（dc02）が見つからない' }
$newItem = $newItem.Substring(0, $newItem.Length - '<h2 class="dc02">'.Length) + '<h2 class="dc02$1'
$tailPart = $h2Pattern.Replace($tailPart, $newItem, 1)
# 色相を最多件数で振り直す
$itemCount = [regex]::Matches($tailPart, '<h2 class="dc\d{2}[ "]').Count
$chapter1Count = [regex]::Matches($headPart, '<h2 class="dc\d{2}[ "]').Count
# 2章の番号が 1 から抜けずに続くかを確かめる（差し込みの失敗を黙って通さない）
$itemNumbers = @([regex]::Matches($tailPart, '<div class="item dc(\d{2})[ "]') | ForEach-Object { [int]$_.Groups[1].Value })
if ($itemNumbers.Count -ne $itemCount -or (Compare-Object $itemNumbers (1..$itemCount))) { throw "2章の番号が連番になっていない（見出し $itemCount 件、枠 $($itemNumbers.Count) 件）" }
$maxCount = [math]::Max($itemCount, $chapter1Count)
$hueLines = (1..$maxCount | ForEach-Object { $hueValue = [math]::Round(280 - 280 / ($maxCount - 1) * ($_ - 1), 1); '.dc{0:D2} {{ --dh: {1,5}; }}' -f $_, $hueValue }) -join "`n"
$headPart = [regex]::Replace($headPart, '(?m)^\.dc01 \{[\s\S]*?(?=\n(?!\.dc\d{2} ))', $hueLines)
[System.IO.File]::WriteAllText($targetFile, $headPart + $tailPart, (New-Object System.Text.UTF8Encoding($true)))
Write-Host "追加: $RepoName（2章 $itemCount 件）"
