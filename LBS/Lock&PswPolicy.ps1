$exportFile = "C:\Temp\local_policy.inf"
$modifiedFile = "C:\Temp\local_policy_mod.inf"

# Créer dossier si nécessaire
if (-not (Test-Path "C:\Temp")) {
    New-Item -ItemType Directory -Path "C:\Temp" -Force | Out-Null
}

# Exporter la configuration actuelle
Write-Host "[INFO] Export de la configuration..."
secedit /export /cfg $exportFile

if (!(Test-Path $exportFile)) {
    Write-Error "Export échoué. Fichier absent."
    exit 1
}

# Lire fichier, ligne par ligne
$content = Get-Content $exportFile

# Liste des remplacements (façon sed : clé => nouvelle valeur)
$replacements = @{
    "MinimumPasswordLength" = "MinimumPasswordLength = 12"
    "PasswordComplexity"    = "PasswordComplexity = 1"
    "PasswordHistorySize"   = "PasswordHistorySize = 24"
}

#applocker
$xmlUrl  = "https://raw.githubusercontent.com/FabFromTheSnow/IT-Homemade/refs/heads/main/LBS/DefaultDesktopAPPLOCK.xml"
$tempXml = "$env:TEMP\AppLockerPolicy.xml"
Invoke-WebRequest -Uri $xmlUrl -OutFile $tempXml -UseBasicParsing

# Activer AppLocker
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "AppLocker" -Value 1 -Type DWord
Set-Service AppIDSvc -StartupType Automatic -ErrorAction SilentlyContinue
Start-Service AppIDSvc -ErrorAction SilentlyContinue

# Charger le fichier et l’appliquer
Set-AppLockerPolicy -XMLPolicy $tempXml   # <-- CHEMIN du fichier XML, pas son contenu !

Write-Host "[OK] AppLocker activé et règles importées depuis $tempXml"

# Nettoyage
Remove-Item $tempXml -Force -ErrorAction SilentlyContinue

Write-Host "AppLocker activé et règles importées."

# Appliquer les remplacements
foreach ($key in $replacements.Keys) {
    if ($content -match "^$key\s*=") {
        $content = $content -replace "^$key\s*=.*", $replacements[$key]
    }
    else {
        # Ajouter à la fin de [System Access] si non présent
        $index = $content.IndexOf('[System Access]')
        if ($index -ge 0) {
            $endOfSection = ($content[($index+1)..($content.Length - 1)] | Select-String "^\[" | Select-Object -First 1).LineNumber
            $insertAt = if ($endOfSection) { $index + $endOfSection } else { $content.Length }
            $content = $content[0..($insertAt - 1)] + $replacements[$key] + $content[$insertAt..($content.Length - 1)]
        }
    }
}

# Écrire la version modifiée avec encodage correct
$content | Out-File -Encoding Unicode -FilePath $modifiedFile -Force

# Réimporter via secedit
Write-Host "[INFO] Application des modifications..."
secedit /configure /db C:\Windows\Security\Local.sdb /cfg $modifiedFile /areas SECURITYPOLICY

if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Politique appliquée."
} else {
    Write-Warning "[ERREUR] Code : $LASTEXITCODE"
}

Write-Host "[INFO] Application du verrouillage automatique après 10 minutes d'inactivité..."

# === 1. Activer l'écran de veille sécurisé (demande de mot de passe) ===
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "ScreenSaveActive" -Value "1"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "ScreenSaverIsSecure" -Value "1"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "ScreenSaveTimeOut" -Value "600"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "SCRNSAVE.EXE" -Value "C:\Windows\System32\logon.scr"

# Appliquer immédiatement la configuration utilisateur
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters

Write-Host "[OK] Verrouillage écran de veille activé après 10 minutes."

# === 2. Configurer la mise en veille après 10 minutes d'inactivité ===

Write-Host "[INFO] Configuration du délai de mise en veille à 10 minutes..."

# Pour le plan d'alimentation actif
$scheme = powercfg /getactivescheme | ForEach-Object {
    if ($_ -match 'GUID:\s+([a-f0-9\-]+)') { $matches[1] }
}

# Définit la veille sur secteur et batterie à 10 minutes (600 sec)
powercfg /change standby-timeout-ac 10
powercfg /change standby-timeout-dc 10

Write-Host "[OK] Veille configurée à 10 minutes (secteur & batterie)."

Write-Host "[INFO] Désactivation complète de l’AutoRun sur tous les lecteurs et utilisateurs..."

# désactiver AutoRun pour tous les lecteurs (GPO-like)
New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\Explorer" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Explorer" -Name "NoDriveTypeAutoRun" -Type DWord -Value 0xFF
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Explorer" -Name "NoAutoRun" -Type DWord -Value 1

# appliqué aussi au cas où GPO pas prise en compte
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -Type DWord -Value 0xFF

# Désactiver AutoPlay pour tous les utilisateurs
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1
