Write-host "hello world"
$name=Read-host "Enter your name"
Write-host "entered name is "$name
$surname = "ghorpade"
Write-host "Full name is "$name $surname

if($name -eq "amit") {
Write-host "you are correct"
}else{
Write-host "you are incorrect"
}

do{
Write-host "you in do loop"

$readinput = Read-host "enter 1"
}while($readinput -ne 1)

$input = Read-host "give me a number"

while($input -eq 0){
Write-host "You are in while loop and input is"$input
$input+=1
Write-host "near to if condition"$input
 if($input -eq '01'){
 Write-host "in condition "
 break
 }else{
 Write-host "else condition"
 }
}

$text = 5
for($i=0;$i -lt 5;$i++){
Write-host "We are in foor loop "$i
if($i -eq 4)
{
$text+=$i
Write-host "value of text is "$text
}

}

$myArray = "The", "world", "is", "everlasting"

foreach($arrayobject in $myArray){
Write-host "put on elements on console" $arrayobject  #accessing using variable
}
for($i=0;$i -lt $myArray.Length;$i++){
Write-host "we are in foor loop"$myArray[$i]  #accessing using array's position
}

#break, continue, do, else, elseif, for, foreach, function, filter, in, if, return, switch, until, where, while.

$input =7
switch($input){

	1{ Write-host " given value is " $input  }
	2{ Write-host " given value is " $input  }
	3{ Write-host " given value is " $input  }
	4{ Write-host " given value is " $input  }
	5{ Write-host " given value is " $input  }
	6{ Write-host " given value is " $input  }
	default {Write-host "default condition"}

}

Function Get-BatAvg{
Param ($Name, $Runs, $Outs)
$Avg = [int]($Runs / $Outs*100)/100 
Write-Output "$Name's Average = $Avg, $Runs, $Outs"
}
if($input -eq 1){
Write-host " If condition given value is " $input 
}elseif($input -eq 1)
{
Write-host " If condition given value is " $input }elseif($input -eq 2){
Write-host " If condition given value is " $input }elseif($input -eq 3){
Write-host " If condition If condition given value is " $input }elseif($input -eq 4){
Write-host " If condition given value is " $input }elseif($input -eq 5){
Write-host " If condition given value is " $input }elseif($input -eq 6){
Write-host " If condition given value is " $input }else{
Write-host "If condition you are in else condifiotn"
Get-BatAvg Bradman 6996 70
Get-BatAvg Virat 6000 65
}


Function readfile{
Param($filename)
$readfiletext = Get-Content $filename
Write-host "content of file is "$readfiletext

}
#reading file,writing file and other netwrok commands
#read file and append some data to that file

readfile "D:\test.txt"
$readfiletext = "Write-Host 'hello world'"
$readfiletext | Add-Content "D:\test.txt"
readfile "D:\test.txt"



# = n     Equals n
#    += n     Increase value by n (for strings will append n to the string)
#    -= n     Decrease the value by n
#    *= n     Multiply the value by n (for strings, duplicate the string n times)
#    /= n     Divide the value by n
#    %= n     Divide the value by n and assign the remainder (modulus)








#-eq -ne -gt -lt -gte -lte 