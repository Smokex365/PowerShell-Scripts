# Checks for Administrator privileges and opens an elevated prompt is user has Administrator rights
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
	$arguments = "& '" + $myinvocation.mycommand.definition + "'"
	Start-Process powershell -Verb runAs -ArgumentList $arguments -WindowStyle Hidden
	Break
}

#Start-Process wt.exe "-WindowStyle Hidden"
Start-Process -FilePath "$env:USERPROFILE\AppData\Local\Microsoft\WindowsApps\Microsoft.WindowsTerminal_8wekyb3d8bbwe\wt.exe"
