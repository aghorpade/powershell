Write-host "testing"
& iex "cf login" | Tee-Object -Variable foobar
# dir list is printed and result is also stored in $foobar
#$foobar.Count # will return the dir cmd's output as an Object[]
#Write-host $foobar
Write-host "========================"
foreach ($element in $foobar) {
	Write-host $element
}

& iex "cf org-users mac"
