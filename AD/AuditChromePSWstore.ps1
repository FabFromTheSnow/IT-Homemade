#activate audit acl on chrome password store
$UserFolders = Get-ChildItem -Path "C:\Users" -Directory
$UserList = $UserFolders.Name

foreach($user in $UserList){
    $path = "C:\Users\" + $user + "\AppData\Local\Google\Chrome\User Data\Default\Login Data"
    if (Test-Path $path){
        $Acl = Get-Acl $path
        $AuditRule = New-Object System.Security.AccessControl.FileSystemAuditRule("Tout le monde", "FullControl", "None", "None", "Success,Failure")
        $Acl.AddAuditRule($AuditRule)
        Set-Acl -Path $path -AclObject $Acl
        Write-Host "Audit configuré pour $user"
    }
    else {
        Write-Host "Path doesn't exist or isn't accessible for $user"
    }
}
