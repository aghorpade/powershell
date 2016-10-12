Write-host "testing"
$command="cf login"
iex $command
echo $output
$spacename = Read-Host "please select space name"
echo $spacename