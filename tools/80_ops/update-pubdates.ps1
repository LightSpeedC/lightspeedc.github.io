# docs/index.html の各資料の更新日（span.pubdate の「更新:」）を、リンク先リポジトリの pushed_at（JST）に合わせる
# 更新日が公開日より後のときだけ付け、それ以外は外す
$ErrorActionPreference = 'Stop'
$targetFile = Join-Path $PSScriptRoot '../../docs/index.html'
$htmlText = [System.IO.File]::ReadAllText($targetFile)
$repoNames = [regex]::Matches($htmlText, 'github\.com/LightSpeedC/([^/#"]+)') | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique
$checkCount = 0
$changeCount = 0
foreach ($repoName in $repoNames) {
	$pushedAt = gh api "repos/LightSpeedC/$repoName" --jq .pushed_at
	if (-not $pushedAt) { Write-Host "取得できず: $repoName"; continue }
	$pushDate = ([datetime]::Parse($pushedAt).ToUniversalTime().AddHours(9)).ToString('yyyy-MM-dd')
	$pattern = '(github\.com/LightSpeedC/' + [regex]::Escape($repoName) + '[/#"][\s\S]*?<span class="pubdate">📅 作成: \d{4}-\d{2}-\d{2} / 公開: (\d{4}-\d{2}-\d{2}))( / 更新: \d{4}-\d{2}-\d{2})?(</span>)'
	$regexObj = [regex]::new($pattern)
	if (-not $regexObj.IsMatch($htmlText)) { continue }
	$checkCount++
	$newText = $regexObj.Replace($htmlText, [System.Text.RegularExpressions.MatchEvaluator]{
		param($m)
		$suffix = if ($pushDate -gt $m.Groups[2].Value) { " / 更新: $pushDate" } else { '' }
		$m.Groups[1].Value + $suffix + $m.Groups[4].Value
	}, 1)
	if ($newText -cne $htmlText) { $changeCount++; Write-Host "変更: $repoName → $pushDate"; $htmlText = $newText }
}
if ($changeCount -gt 0) { [System.IO.File]::WriteAllText($targetFile, $htmlText, (New-Object System.Text.UTF8Encoding($true))) }
Write-Host "確認件数: $checkCount / 変更件数: $changeCount"
