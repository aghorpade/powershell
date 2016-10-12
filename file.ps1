cls
Write-host "==================================================================================================="
Write-host "|     Welcome to powershell script to apply specific role to user on pivotal cloud foundry        |"
Write-host "|                                                                                                 |"
Write-host "| created by -             date -                                                                 |"
Write-host "==================================================================================================="
#keep script and confirguration file under same directory path
#get the directory of script file and read content of FoundationConfigurations.txt file which contains data in key:value format
$content = Get-content $PSScriptRoot"FoundationConfigurations.txt"
$keyArray=@()
$valueArray=@()
#iterate over content and split it by = symbol and store them in key and value array
Foreach($element in $content){
$array=$element.Split("=")
$keyArray+=$array[0]
$valueArray+=$array[1] 
}
#iterate over key array to display environment options to user
do{
$j=0
for($i=0;$i -lt $keyArray.Length;$i++){
$j++
Write-host $j $keyArray[$i]
}
$envOption = Read-host "Please select environment from above options"
}while($envOption -lt 1 -or $envOption -gt $keyArray.Length)
#use selected option value to read api endpoint url from value array
#execute cf login command
$logincommand = "cf login -a "+$valueArray[$envOption-1]
& iex $logincommand
#need to handle login failur condition
#read organizations names in organizations array object
& iex "cf orgs" | Tee-Object -Variable organizations | Out-Null
$org=@()
$j=0
#read organization names in organization array to display it on console
for($i=0;$i -lt $organizations.Length;$i++) {
	if($i -gt 2){
	$org +=$organizations[$i]
	}
}
Write-host "======================== Organizations List =============================="
foreach ($element in $org) {
	$j++
	Write-host $j $element
}
#Readt input from user to select organization
$env = read-host "Select one of the organization from above options:="
while ( $env -lt 1 -or $env -gt $org.Length ){
   $j=0
   foreach ($element in $org) {
	$j++
	Write-host $j $element
}
  [Int]$env = read-host "Select one of the organization from above options:=" 
}
	 
Write-host "selected organization is:="$org[$env-1]
$targetorg = $org[$env-1]
#apply target organization using below command
$targetedorg = "cf target -o "+$targetorg
& iex $targetedorg
#get the spaces for a targated organization
$getspacescommand="cf spaces"
& iex $getspacescommand | Tee-Object -Variable spaces | Out-Null
$spacelist=@()
$j=0
#read space name and store them in spaceList oject
for($i=0;$i -lt $spaces.Length;$i++) {
	if($i -gt 2){
	$spacelist +=$spaces[$i]
	}
}
Write-host "======================== Spaces List ======================================="
$j=0
foreach ($element in $spacelist) {
	$j++
	Write-host $j $element
}
#read input from user to select space
$env = read-host "Select one of the option from above list:="
while ( $env -lt 1 -or $env -gt $spacelist.Length ){
   $j=0
foreach ($element in $spacelist) {
	$j++
	Write-host $j $element
}
  [Int]$env = read-host "Select one of the option from above list:=" 
}
$targetspace = $spacelist[$env-1]
Write-host "selected space is:="$targetspace
#get username from user
$username = read-host "Please enter username:=" 
#show space role options and read input from user
Write-host "Available Space Roles"
Write-host "1. SpaceManager"
Write-host "2. SpaceDeveloper"
Write-host "3. SpaceAuditor"
$env = read-host "Select Space Role options:="
while ( $env -lt 1 -or $env -gt 3 ){
	Write-host "1. SpaceManager"
	Write-host "2. SpaceDeveloper"
	Write-host "3. SpaceAuditor"
	[Int]$env = read-host "Select Space Role options:=" 
}
$spacerole=""
switch ($env)
     {
           1 {
                $spacerole = "SpaceManager"
           } 
		   2 {
                $spacerole = "SpaceDeveloper"
           } 
		   3 {
                $spacerole = "SpaceAuditor"
           } 
	 }

Write-host " You have selected organization"$targetorg"space" $targetspace"role" $spacerole" for user" $username
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
	#execute cf command to apply selected role to user on given space and organization
	Write-host "commnd to be executed"$roletouser
	& iex $roletouser | Tee-Object -Variable Result | Out-Null
	if($Result[0] -eq "FAILED"){
	Write-host "=============================== FAILED ===================================="
	Write-host "Faced error while applying role to given a user. Error StackTrace:=" $Result
	}else{
    "We have applied script to provide proper role to user."}
}
else
{
   "No role has been provided to user."
}

