#Based on https://github.com/joshmadakor1/AD_PS/blob/master/1_CREATE_USERS.ps1
# ----- Edit these Variables for your own Use Case ----- #
$PASSWORD_FOR_USERS   = "Password1"
# save people name as First-Name Last-Name
$USER_FIRST_LAST_LIST = Get-Content .\names.txt


# Convert password to secure string
$password = ConvertTo-SecureString $PASSWORD_FOR_USERS -AsPlainText -Force

# Prompt for the existing OU where users will be added
$ouName = Read-Host "Please enter the name of the OU (e.g., 'Internal')"
$rootDSE = ([ADSI]"LDAP://RootDSE").defaultNamingContext
$ouPath = "ou=$ouName,$rootDSE"

$errorList = @()  # Initialize an array to hold usernames that could not be created

foreach ($n in $USER_FIRST_LAST_LIST) {
    $first = $n.Split(" ")[0].ToLower()
    $last = $n.Split(" ")[1].ToUpper()  # Capitalize the entire last name
    $username = "$($first.Substring(0,1)).$last".ToLower() # Corrected username format: first initial + dot + last name (all uppercase)
    Write-Host "Creating user: $($username)" -BackgroundColor Black -ForegroundColor Cyan
    
    try {
        New-AdUser -AccountPassword $password `
                   -GivenName $first `
                   -Surname $last `
                   -DisplayName "$($first.Substring(0,1).ToUpper()). $last" `
                   -Name $username `
                   -EmployeeID $username `
                   -Path $ouPath `
                   -Enabled $true `
                   -ErrorAction Stop `
                   -ChangePasswordAtLogon $true
    } catch {
        Write-Host "Failed to create user: $username. Error: $($_.Exception.Message)" -ForegroundColor Red
        $errorList += $username  # Add the failed username to the list
    }
}

# Output the list of failed usernames to error.txt
if ($errorList.Count -gt 0) {
    $errorList | Out-File .\error.txt
}
