# Checks for Administrator privileges and opens an elevated prompt is user has Administrator rights
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
	$arguments = "& '" + $myinvocation.mycommand.definition + "'"
	Start-Process powershell -Verb runAs -ArgumentList $arguments -WindowStyle Hidden
	Break
}

$gs = "$env:ProgramFiles/Siber Systems/GoodSync/"

Start-Process -FilePath "$gs/GoodSync-v10.exe"
Start-Process -FilePath "$gs/gs-server.exe" -WindowStyle Hidden
$gss = Get-Process gs-server
Wait-Process -Name "GoodSync-v10"
Stop-Process -Id $gss.Id