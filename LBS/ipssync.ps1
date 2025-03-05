# powershell to sync IPs database from honeypot to other servers
# downlaod sqlite here https://www.sqlite.org/download.html
cd "C:\Users\user\Documents\FreeSOC"
git pull

# Load sqlite dll
Add-Type -Path "C:\Program Files\SQLITE\System.Data.SQLite.dll"

# create connection string
$connectionString = "Data Source=C:\Program Files (x86)\mytopsecretips\data\sqlite.db" #change sqlite db path
$connection = New-Object System.Data.SQLite.SQLiteConnection($connectionString)
$connection.Open()

# query for ips added in last 24 hours
$command = $connection.CreateCommand()
$command.CommandText = "SELECT ipaddress FROM firewallrules WHERE status != '3' AND createdon >= datetime('now', '-1 day') AND createdon < datetime('now')" #ignore whitelist status
$reader = $command.ExecuteReader()

# extract ip and create list
$ipAddresses = New-Object System.Collections.Generic.List[string]

while ($reader.Read()) {
    $ipAddresses.Add($reader["ipaddress"].ToString())
}

$outputFile = "C:\Users\user\Documents\FreeSoc\list\BADipv4"

# Write list in the file
$ipAddresses | Out-File -FilePath $outputFile -Encoding UTF8 -Append

# Disconnect from sqlite db
$reader.Close()
$connection.Close()


#push on github for sync
cd "C:\Users\user\Documents\FreeSOC"
git add list/BADipv4
git commit -m "auto commit"
git push origin main


