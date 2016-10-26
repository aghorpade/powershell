cls
Write-host "==================================================================================================="
Write-host "|     Welcome to powershell script to apply specific role to user on pivotal cloud foundry        |"
Write-host "|                                                                                                 |"
Write-host "| created by -             date -                                                                 |"
Write-host "==================================================================================================="
#keep script and confirguration file under same directory path
#get the directory of script file and read content of FoundationConfigurations.txt file which contains data in key:value format
$content = Get-content $PSScriptRoot"\FoundationConfigurations.txt"
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
#authorization_endpoint will be "https://login.run.pivotal.io" append it with /oauth/token
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
#pass on Authorization : Bearer access_token as header
$beareretoken="Bearer "+$access_token
$headers.add('Authorization', $beareretoken)

#Write-host $orguri
$result =Invoke-RestMethod -Method GET -Uri "$orguri" -Headers $headers

#two array - one for storing guid and one for storing name of organization
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
#to get all spaces under organization we need to call /v2/organizations/{orguid}/spaces
$spaceUri=$baseUri+"/v2/organizations/"+$orgGuidArray[$env-1]+"/spaces"

$result = Invoke-RestMethod -Method GET -Uri "$spaceUri" -Headers $headers
#Write-host "result of app"$result.resources
$spacearray=@()
$spaceGuidArray=@()
for($i=0;$i -lt $result.resources.Length;$i++){
$spacearray+=$result.resources[$i].entity.name
$spaceGuidArray+=$result.resources[$i].metadata.guid

#/v2/spaces/be1f9c1d-e629-488e-a560-a35b545f0ad7/apps to list all apps in space
$appsUri=$baseUri+"/v2/spaces/"+$result.resources[$i].metadata.guid+"/apps"
$appresult = Invoke-RestMethod -Method GET -Uri "$appsUri" -Headers $headers

for($j=0;$j -lt $appresult.resources.Length;$j++)
{
$buildpackresult= $appresult.resources[$j].entity.name+" ,"+$appresult.resources[$j].entity.buildpack+" ,"+$result.resources[$i].entity.name
Write-host $buildpackresult
$buildpackresult | Out-File -Append myProducts.txt
}
}
