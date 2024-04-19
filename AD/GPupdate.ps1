$computers = Get-ADComputer -Filter *  # Retrieves all computers in the domain
foreach ($computer in $computers) {
    Invoke-Command -ComputerName $computer.Name -ScriptBlock {
        gpupdate /force
    } -AsJob
}
