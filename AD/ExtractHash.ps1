#Show and save all process hash
$Paths = Get-Process | Select-Object -ExpandProperty Path | Sort-Object -Unique
foreach($path in $paths){
    $hs = $(Get-FileHash -Algorithm SHA256 $path).Hash
    $filename = Split-Path -Path $path -Leaf 
    echo "$($filename):$hs"
    echo "$($filename):$hs" >> .\sha256procces
}
