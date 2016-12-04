#below is a script that can be used to send email using Powershell.

 function sendMail{

$From = "ghorpade.a.g@gmail.com"
$To = "ghorpade.a.g@gmail.com"
$SMTPServer = "smtp.gmail.com"
$SMTPPort = "587"
$Username = "xxxxxxxx"
$Password = "xxxxxx*"
$subject = "Email Subject"
$body = "This is demo test"

$smtp = New-Object System.Net.Mail.SmtpClient($SMTPServer, $SMTPPort);

$smtp.EnableSSL = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
$smtp.Send($From, $To, $subject, $body);

}

#Calling function
sendMail
