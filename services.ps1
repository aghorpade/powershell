# Script to check windows service is running or stopped
function checkService{
 param($ServiceName)
$arrService = Get-Service -Name $ServiceName
if ($arrService.Status -ne "Running"){
Start-Service $ServiceName
Write-Host "Starting " $ServiceName " service"
" ---------------------- "
" Service is now started"
}
if ($arrService.Status -eq "running"){
Write-Host "$ServiceName service is already started"
}
}
for(;;) {
 try {
  # invoke the worker script
  checkService -ServiceName 'MySQL56'
 }
 catch {
  # do something with $_, log it, more likely
 }

 # wait for a minute
 Start-Sleep 60
}


#To run this application continously without stop and show to user
#start /min powershell -WindowStyle Hidden -Command C:\ROM\_110106_022745\Invoke-MyScript.ps1
