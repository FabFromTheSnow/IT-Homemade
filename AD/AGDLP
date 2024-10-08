 #Create group for AGDLP Method
 #Groups will be created under an OU called groupe
<# Made for following tree 
- Company OU
    -OU_Service1
    -OU_Service2
    -OU_Service3
 
#>
$rootDSE = ([ADSI]"LDAP://RootDSE").defaultNamingContext #Automatically define end of DN
$Fileserver = "Srv-fileserver.tp01.labo" #Specify server hosting shares

$mainOU = "Teckinfo" #Company OU containing other OU
$ouPath = "Ou=$mainOU,$rootDSE"

$OuList = Get-ADOrganizationalUnit -LDAPFilter '(name=*)' -SearchBase $ouPath -SearchScope OneLevel
$OuListName = $OuList.Name

New-ADOrganizationalUnit -Name "Groupe" -Path $rootDSE

foreach($name in $OuListName)
{
    New-ADGroup -Name "GG_$name" -SamAccountName "GG_$name" -GroupScope Global -DisplayName "GG_$name" -Path "Ou=$mainOU,$rootDSE"
}

$ShareList = Get-WmiObject -Class Win32_Share -ComputerName $Fileserver | Where-Object { $_.Name -notmatch '^(NETLOGON|IPC|SYSVOL$|.*\$)' }
$ShareList = $ShareList.Name

foreach($SharedFolder in $ShareList)
{
    New-ADGroup -Name "DL_$($SharedFolder)_RW" -SamAccountName "DL_$($SharedFolder)_RW" -GroupScope DomainLocal -DisplayName "DL_$($SharedFolder)_RW" -Path "Ou=Groupe,$rootDSE"
    New-ADGroup -Name "DL_$($SharedFolder)_RO" -SamAccountName "DL_$($SharedFolder)_RO" -GroupScope DomainLocal -DisplayName "DL_$($SharedFolder)_RO" -Path "Ou=Groupe,$rootDSE"
}

