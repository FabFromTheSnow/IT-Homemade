# ProgID for the Addon to activate
$addonProgID = "LBSOutlook.AddinModule"

# Start Outlook COM Object
$outlook = New-Object -ComObject Outlook.Application
$Addons = $outlook.COMAddIns

$addon = $Addons.Item($addonProgID)

if ($addon) {
    $addon.Connect = $true
    Write-Host "Addon with ProgID $addonProgID activated."
} else {
    Write-Host "Addon with ProgID $addonProgID not found."
}

# Cleanup
$null = [System.Runtime.InteropServices.Marshal]::ReleaseComObject($outlook)
