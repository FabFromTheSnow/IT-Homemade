#find all sid excluding classes that are no real uers
$SIDs = Get-ChildItem -Path Registry::HKEY_USERS | Where-Object { $_.Name -notmatch "_Classes$" }

foreach ($SID in $SIDs) {
    #run key that contains startupt program
    $keyPath = "Registry::$($SID.Name)\Software\Microsoft\Windows\CurrentVersion\Run"

    # Verify key existence
    if (Test-Path $keyPath) {
        # Check if the 'Teams' entry exists
        $teamsEntry = Get-ItemProperty -Path $keyPath -Name "com.squirrel.Teams.Teams" -ErrorAction SilentlyContinue

        if ($teamsEntry) {
            # Remove the 'Teams' entry
            Remove-ItemProperty -Path $keyPath -Name "com.squirrel.Teams.Teams" -ErrorAction Stop
            Write-Output "Removed Teams from $keyPath"
        } else {
            Write-Output "No Teams entry found in $keyPath"
        }
    } else {
        Write-Output "Key path does not exist: $keyPath"
    }
}
