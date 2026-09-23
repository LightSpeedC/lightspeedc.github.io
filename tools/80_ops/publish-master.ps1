param(
	[Parameter(Mandatory)][string]$MergeMessageFile,  # マージコミットメッセージ（heredocで作ったファイル）
	[Parameter(Mandatory)][string]$TagName,           # 例: 2026/09/23_master-02
	[Parameter(Mandatory)][string]$TagMessage
)

$ErrorActionPreference = 'Stop'

function Invoke-GitStep {
	param([string[]]$GitArgs)
	& git @GitArgs
	if ($LASTEXITCODE -ne 0) {
		Write-Error "git $($GitArgs -join ' ') が失敗しました（終了コード $LASTEXITCODE）"
		exit $LASTEXITCODE
	}
}

Invoke-GitStep @('switch', 'master')
Invoke-GitStep @('merge', '--no-ff', 'develop', '-F', $MergeMessageFile)
Invoke-GitStep @('tag', '-a', $TagName, '-m', $TagMessage)
Invoke-GitStep @('switch', 'develop')
Write-Host ("push: {0}" -f (Get-Date).ToString('MM/dd HH:mm'))
Invoke-GitStep @('push', 'origin', 'develop', 'master', $TagName)
