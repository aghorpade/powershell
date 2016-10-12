Write-Host "Hello, World"
$cloudhost = Read-Host "Enter Cloud Foundry Host URL"
echo $host1
Write-Host ""
$message  = 'Available Orgnization details'
$question = 'Please select one of the below org :'

$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&1. devetest'))
Write-Host "\n"
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&2. devprod'))
Write-Host "\n"
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&3. devsandbox'))
$decision = $Host.UI.PromptForChoice($message, $question, $choices, 0)
switch ($decision){
    0 {"You entered selected"; break}
    1 {"You entered shutdown"; break}
}

  $caption = "Please Confirm"    
    $message = "Are you Sure You Want To Proceed:"
    [int]$defaultChoice = 0
    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Do the job."
    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Do not do the job."
    $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
    $choiceRTN = $host.ui.PromptForChoice($caption,$message, $options,$defaultChoice)

if ( $choiceRTN -ne 1 )
{
   "Your Choice was Yes" + $yes
}
else
{
   "Your Choice was NO"
}

Write-Host "Thank you"