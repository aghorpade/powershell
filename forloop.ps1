cls
Write-host "==================================================================================================="
Write-host "|     Welcome to powershell script to apply specific role to user on pivotal cloud foundry        |"
Write-host "|                                                                                                 |"
Write-host "| created by -             date -                                                                 |"
Write-host "==================================================================================================="
Write-host "Pivotal Cloud Foundry API Endpoint URL's"
Write-host "1. https://api.run.pivotal.io"
Write-host "2. https://apidev.run.pivotal.io"
Write-host "3. https://apiSandbox.run.pivotal.io"
Write-host "4. https://apiprod.run.pivotal.io"
$env = read-host "Select 1 to 4 APi Endpoint URL "
while ( $env -lt 1 -or $env -gt 4 ){
    Write-host "1. https://api.run.pivotal.io"
	Write-host "2. https://apidev.run.pivotal.io"
	Write-host "3. https://apiSandbox.run.pivotal.io"
	Write-host "4. https://apiprod.run.pivotal.io"
	[Int]$env = read-host "Select 1 to 4 APi Endpoint URL " 
}
$hostapiendpointurl=""
switch ($env)
     {
           1 {
                $hostapiendpointurl = "https://api.run.pivotal.io"
           } 
		   2 {
                $hostapiendpointurl = "https://apidev.run.pivotal.io"
           } 3 {
                $hostapiendpointurl = "http://apiSandbox.pivotal.com"
           } 4 {
                $hostapiendpointurl = "http://apiprod.pivotal.com"
           }
	 }

$logincommand = "cf login -a "+$hostapiendpointurl
& iex $logincommand
& iex "cf orgs" | Tee-Object -Variable organizations
cls
Write-host "========================"
$org=@()
$j=0
for($i=0;$i -lt $organizations.Length;$i++) {
	if($i -gt 2){
	$org +=$organizations[$i]
	}
}
Write-host "======================== this is orgazniation list"
foreach ($element in $org) {
	$j++
	Write-host $j $element
}
Write-host "Organization available on API endpoint"
$env = read-host "Select from below options "
while ( $env -lt 1 -or $env -gt $org.Length ){
   $j=0
   foreach ($element in $org) {
	$j++
	Write-host $j $element
}
  [Int]$env = read-host "Select one of the option " 
}
	 
Write-host "selectedf organization is " $org[$env-1]
$targetorg = $org[$env-1]
$targetedorg = "cf target -o "+$targetorg
& iex $targetedorg
$getspacescommand="cf spaces"
& iex $getspacescommand | Tee-Object -Variable spaces
Write-host "========================"
$spacelist=@()
$j=0
for($i=0;$i -lt $spaces.Length;$i++) {
	if($i -gt 2){
	$spacelist +=$spaces[$i]
	}
}
Write-host "========================"
$j=0
foreach ($element in $spacelist) {
	$j++
	Write-host $j $element
}
Write-host "Spaces available on API endpoint"
$env = read-host "Select from below option :"
while ( $env -lt 1 -or $env -gt $spacelist.Length ){
   $j=0
foreach ($element in $spacelist) {
	$j++
	Write-host $j $element
}
  [Int]$env = read-host "Select one of the option :" 
}
$targetspace = $spacelist[$env-1]
Write-host "selectedf space is " $targetspace
$username = read-host "Please enter username " 
Write-host "Enter Role from below options"
Write-host "1. SpaceManager"
Write-host "2. SpaceDeveloper"
Write-host "3. SpaceAuditor"
$env = read-host "Select 1 to 3 space role"
while ( $env -lt 1 -or $env -gt 4 ){
	Write-host "1. SpaceManager"
	Write-host "2. SpaceDeveloper"
	Write-host "3. SpaceAuditor"
	[Int]$env = read-host "Select 1 to 3 space role" 
}
$spacerole=""
switch ($env)
     {
           1 {
                $spacerole = "SpaceManager"
           } 
		   2 {
                $spacerole = "SpaceDeveloper"
           } 3 {
                $spacerole = "SpaceAuditor"
           } 
	 }


Write-host " You have selected organization" $targetorg "space" $targetspace "role" $spacerole "for user"  $username "."
    $caption = "Please Confirm"    
    $message = "Are you Sure You Want To Proceed:"
    [int]$defaultChoice = 1
    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Do the job."
    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Do not do the job."
    $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
    $choiceRTN = $host.ui.PromptForChoice($caption,$message, $options,$defaultChoice)

if ( $choiceRTN -ne 1 )
{
	$roletouser = "cf set-space-role " + $username +" "+$targetorg + $targetspace + $spacerole
	Write-host "commnd to be executed"$roletouser
	& iex $roletouser | Tee-Object -Variable rolecommand
	Write-host "Executed command result"$rolecommand
    "We have applied script to provide proper role to user."
}
else
{
   "No role has been provided to user."
}

