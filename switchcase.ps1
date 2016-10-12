
Write-host "Welcome to powershell script to apply specific role to user on pivotal cloud foundry"
Write-host "Environments available"
Write-host "1. Development"
Write-host "2. DeveTest"
Write-host "3. UAT sandbox"
Write-host "4. Production"
$env = read-host "Select 1 to 4 environment "
while ( $env -lt 1 -or $env -gt 4 ){
    Write-host "1. Development"
	Write-host "2. DeveTest"
	Write-host "3. UAT sandbox"
	Write-host "4. Production"
  [Int]$env = read-host "Select 1 to 4 environment " 
}

$username = read-host "Please enter username"
Write-host "Orginzation available"
Write-host "1. Digital"
Write-host "2. Transformation"
Write-host "3. Pipeline"
Write-host "4. Production"
$organization = read-host "Select 1 to 4 organization "
while ( $organization -lt 1 -or $organization -gt 4 ){
    Write-host "1. Digital"
	Write-host "2. Transformation"
	Write-host "3. Pipeline"
	Write-host "4. Production"
  [Int]$organization = read-host "Select 1 to 4 organization " 
}

Write-host "Spaces available"
Write-host "1. dev"
Write-host "2. UAT"
Write-host "3. devtest"
Write-host "4. production"
$space = read-host "Select 1 to 4 space "
while ( $space -lt 1 -or $space -gt 4 ){
    Write-host "1. dev"
	Write-host "2. UAT"
	Write-host "3. devtest"
	Write-host "4. production"
  [Int]$space = read-host "Select 1 to 4 space " 
}
Write-host "Roles available"
Write-host "1. developer"
Write-host "2. admin"
Write-host "3. org manager"
$role = read-host "Select 1 to 3 role "
while ( $role -lt 1 -or $role -gt 3 ){
    Write-host "1. developer"
	Write-host "2. admin"
	Write-host "3. org manager"
  [Int]$role = read-host "Select 1 to 3 role " 
}

Write-host " You have selected environment" $environment " organization " $organization " space "  $space  " role "  $role  " for user "  $username
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

Write-Host "Thank you"



