#powershell script to manage file dehydration with storage sense, administrative tool can open file and therefore prevent file to be dehydrated
#run this script on specific sharepoint sync user folder then access ms-settings:storagepolicies to manually trigger storage sense
$folderPath = ""

# Check if the path exists
if (Test-Path $folderPath) {
    # Get the current date and time
    $currentDate = Get-Date

    # Define the threshold date for 30 days ago
    $thresholdDate = $currentDate.AddDays(-30)

    # Get all files and subfolders in the specified directory, recursively
    $files = Get-ChildItem -LiteralPath $folderPath -Recurse -File

    # Loop through each file and check if it was accessed more than 30 days ago
    foreach ($file in $files) {
        if ($file.LastAccessTime -lt $thresholdDate) {
            # Apply the +U attribute to files that haven't been accessed in the past month
            attrib +U $file.FullName
            Write-Host "Applied +U to: $($file.FullName)"
        }
    }
    Write-Host "Completed applying +U to files not accessed in the past month."
} else {
    Write-Host "The specified path does not exist."
}
