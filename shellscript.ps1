Write-host "Select API Endpoint URL from below options:"
Write-host "1. https://api.run.pivotal.io"
Write-host "2. https://apidev.run.pivotal.io"
Write-host "3. https://apiSandbox.run.pivotal.io"
Write-host "4. https://apiprod.run.pivotal.io"
$hostendpoint = read-host "Enter options between 1 to 4 "
while( $hostendpoint -lt 1 -or $hostendpoint -gt -4 ){
Write-host "1. https://api.run.pivotal.io"
Write-host "2. https://apidev.run.pivotal.io"
Write-host "3. https://apiSandbox.run.pivotal.io"
Write-host "4. https://apiprod.run.pivotal.io"
[Int]$hostendpoint = read-host "Enter options between 1 to 4 "
}
switch ($hostendpoint)
     {
           1 {
                cls
                $hostapiendpointurl = "https://api.run.pivotal.io"
           } 
		   2 {
                cls
                $hostapiendpointurl = "https://apidev.run.pivotal.io"
           } 3 {
                cls
                $hostapiendpointurl = "http://apiSandbox.pivotal.com"
           } 4 {
                $hostapiendpointurl = "http://apiprod.pivotal.com"
           }
	 }
	 
$cflogincommand = "cf login -a " + $spacerolevalue
Write-host $cflogincommand
#look for other option instead of tee-object
& iex "cf login" | Tee-Object -Variable foobar

& iex "cf orgs" | Tee-Object -Variable organizations

Write-host "===========Select Organizations from below options============"
Write-host "organizations"
Write-host $organizations

#get the username
Write-host "Enter username for whom we need to provide specific role"

do{
Write-host "Enter Role from below options"
Write-host "1. SpaceManager"
Write-host "2. SpaceDeveloper"
Write-host "3. SpaceAuditor"
[Int]$SpaceRoleChoice = read-host "Enter options between 1 to 3 "
}while($SpaceRoleChoice -lt 1 -or $SpaceRoleChoice -gt -3)
switch($SpaceRoleChoice)
{
1         {
                cls
                $spacerolevalue = "SpaceManager"
           } 
		   2 {
                cls
                $spacerolevalue = "SpaceDeveloper"
           } 3 {
                cls
                $spacerolevalue = "SpaceAuditor"
           } 
}

Write-host " You have selected organization " $organization " space "  $space  " role "  $spacerolevalue  " for user "  $username
    $caption = "Please Confirm"    
    $message = "Are you Sure You Want To Proceed:"
    [int]$defaultChoice = 1
    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Do the job."
    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Do not do the job."
    $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
    $choiceRTN = $host.ui.PromptForChoice($caption,$message, $options,$defaultChoice)

if ( $choiceRTN -ne 1 )
{
   "We have applied script to provide proper role to user" + $yes
}
else
{
   "No role has been provided to user"
}








