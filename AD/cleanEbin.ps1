# plus vieux que
$cutoff = (Get-Date).AddDays(-7)

# Liste les sids users
$sids = (wmic useraccount get sid | Where-Object { $_ -and ($_ -notmatch 'SID') }).Trim()

$deletedCount = 0
$errors = 0

foreach ($sid in $sids) {
    $RecyclePath = "E:\`$RECYCLE.BIN\$sid"

    if (Test-Path $RecyclePath) {
        Get-ChildItem -Path $RecyclePath -File -Recurse -ErrorAction SilentlyContinue |
            Where-Object { $_.LastWriteTime -lt $cutoff } |
            ForEach-Object {
                try {
                    Remove-Item -LiteralPath $_.FullName -Force -ErrorAction Stop
                    $deletedCount++
                } catch {
                    Write-Warning "Failed to delete: $($_.FullName) -> $($_.Exception.Message)"
                    $errors++
                }
            }
    }
}

Write-Host "Deleted files: $deletedCount"
if ($errors -gt 0) { Write-Host "Errors: $errors" }
