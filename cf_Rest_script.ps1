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
Write-host "Please Enter your credential details :"
$username=Read-host "Email >"
#get password from user
$response = Read-host "Password >" -AsSecureString
$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($response))

#================== Start CF REST API call ========================
$apiKey = "application/x-www-form-urlencoded"
$resource = $valueArray[$envOption-1]  #/http://api.run.pivotal.io
$baseUri=$resource
$uri="/info"
$resource+=$uri
$result = Invoke-RestMethod -Method GET -Uri "$resource"
$authEndpoint=$result."authorization_endpoint"
Write-host $authEndpoint

$OAuthTokenURL=$authEndpoint+"/oauth/token"

#add header values
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", 'application/x-www-form-urlencoded')
$headers.add('Accept','application/json')
$headers.add('Authorization','Basic Y2Y6')

$body = @{
	grant_type="password"
    username=$username
	password=$password
}
#$OAuthTokenURL+=$Body
$OauthResponse=try{
Invoke-RestMethod -Method POST -Uri "$OAuthTokenURL" -Headers $headers -Body $body
}catch{$_.Exception.Response.StatusCode.Value__}
#Write-host "response"$OauthResponse
if($OauthResponse -eq 401){
Write-host "UnAuthorized"
break
}
#get access_token and token_type values
$access_token=$OauthResponse."access_token"
$token_type=$OauthResponse."token_type"
#Write-host $token_type $access_token
#get all apps 
$orguri=$baseUri+"/v2/organizations"
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.add('Accept','application/json')
$beareretoken="Bearer "+$access_token
$headers.add('Authorization', $beareretoken)
#Write-host $orguri
$result =Invoke-RestMethod -Method GET -Uri "$orguri" -Headers $headers


$orgarray=@()
$orgGuidArray=@()
for($i=0;$i -lt $result.resources.Length;$i++){
$orgarray+=$result.resources[$i].entity.name
$orgGuidArray+=$result.resources[$i].metadata.guid
}
Write-host "======================== Organizations List =============================="
$j=0
foreach ($element in $orgarray) {
	$j++
	Write-host $j $element
}
#Readt input from user to select organization
$env = read-host "Select one of the organization from above options:="
while ( $env -lt 1 -or $env -gt $orgarray.Length ){
   $j=0
   foreach ($element in $orgarray) {
	$j++
	Write-host $j $element
}
  [Int]$env = read-host "Select one of the organization from above options:=" 
}
Write-host "selected org is"$orgarray[$env-1]"and guid is " $orgGuidArray[$env-1]
$targetOrg=$orgarray[$env-1]
$targetOrgGuid=$orgGuidArray[$env-1]
#get the organization guid
$spaceUri=$baseUri+"/v2/organizations/"+$orgGuidArray[$env-1]+"/spaces"

$result = Invoke-RestMethod -Method GET -Uri "$spaceUri" -Headers $headers
#Write-host "result of app"$result.resources
$spacearray=@()
$spaceGuidArray=@()
for($i=0;$i -lt $result.resources.Length;$i++){
$spacearray+=$result.resources[$i].entity.name
$spaceGuidArray+=$result.resources[$i].metadata.guid
}
Write-host "======================== Space List =============================="
$j=0
foreach ($element in $spacearray) {
	$j++
	Write-host $j $element
}
#Readt input from user to select organization
$env = read-host "Select one of the space from above options:="
while ( $env -lt 1 -or $env -gt $spacearray.Length ){
   $j=0
   foreach ($element in $spacearray) {
	$j++
	Write-host $j $element
}
  [Int]$env = read-host "Select one of the space from above options:=" 
}
Write-host "selected space is"$spacearray[$env-1]"and space is " $spaceGuidArray[$env-1]
$targetSpace=$spacearray[$env-1]
$targetSpaceGuid=$spaceGuidArray[$env-1]
#url to associate role with user on space v2/spaces/31a74bcf-88c7-4cb2-bdbd-435a190f5c6e/managers

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
                $spacerole = "managers"
           } 
		   2 {
                $spacerole = "developers"
           } 
		   3 {
                $spacerole = "auditors"
           } 
	 }

Write-host " You have selected organization"$targetOrg"space" $targetSpace"role" $spacerole" for user" $username
    $caption = "Please Confirm"    
    $message = "Are you Sure You Want To Proceed:"
    [int]$defaultChoice = 1
    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Do the job."
    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Do not do the job."
    $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
    $choiceRTN = $host.ui.PromptForChoice($caption,$message, $options,$defaultChoice)

if ( $choiceRTN -ne 1 )
{
	#call REST api to assign role to user REST - v2/spaces/31a74bcf-88c7-4cb2-bdbd-435a190f5c6e/managers pass body as -{
    # "username": "user@example.com"}
	
	$spaceAccessURI=$baseUri+"/v2/spaces/"+$targetSpaceGuid+"/"+$spacerole
	Write-host "space acces URL "$spaceAccessURI
	$body = @{
				"username"=$username
			}
	$body = $body | convertto-json
	Write-host "body"$body
	$AccessResponse=try{Invoke-RestMethod -Method POST -Uri "$spaceAccessURI" -Headers $headers -Body $body -ContentType "application/json"
	}catch{$_.Exception.Response.StatusCode.Value__}
	Write-host "response"$AccessResponse
	#Write-host "response from access url"$AccessResponse.StatusCode
    # Write-host "We have applied script to provide proper role to user."
	if($AccessResponse -eq 404 -Or $AccessResponse -eq 401 -Or $AccessResponse -eq 500){
		Write-host "Not able to provide access to user"
	}
}
else
{
   "No role has been provided to user."
}

