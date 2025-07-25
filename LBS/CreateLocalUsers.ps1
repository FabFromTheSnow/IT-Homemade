# Prompt for the group name
$groupName = Read-Host "Enter the group name to add users to"

# Path to the text file containing names
$filePath = ".\users.txt"

# Read each line from the file
Get-Content $filePath | ForEach-Object {
    $line = $_.Trim()
    if ($line -eq "") { return }

    # Split into Firstname and Lastname
    $parts = $line -split "\s+"
    $firstname = $parts[0]
    $lastname = $parts[1]

    # Capitalize first letter for FullName
    $firstnameCap = $firstname.Substring(0,1).ToUpper() + $firstname.Substring(1).ToLower()
    $lastnameCap  = $lastname.Substring(0,1).ToUpper() + $lastname.Substring(1).ToLower()

    # Build username: first letter of first name + "." + lowercase last name
    $username = ($firstname.Substring(0,1) + "." + $lastname).ToLower()

    Write-Host "`n=== Creating user: $username ==="
    $password = Read-Host "Enter password for $username" -AsSecureString

    try {
        # Create the user
        New-LocalUser -Name $username -Password $password -FullName "$firstnameCap $lastnameCap"
        Write-Host "User $username created successfully."

        # Set password never expires
        Set-LocalUser -Name $username -PasswordNeverExpires $true

        # Add to group
        Add-LocalGroupMember -Group $groupName -Member $username
        Write-Host "User $username added to group $groupName."
    }
    catch {
        Write-Warning "Failed to create or add $username : $_"
    }
}
