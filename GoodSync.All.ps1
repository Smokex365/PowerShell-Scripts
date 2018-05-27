# GoodSync All
# This script is designed to install or update Goodsync, stop and disable services (GoodSync Server) and clean up desktop icons.
# Designed for GoodSync 10.x

# Checks for Administrator privileges and opens an elevated prompt is user has Administrator rights
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
	$arguments = "& '" + $myinvocation.mycommand.definition + "'"
	Start-Process powershell -Verb runAs -ArgumentList $arguments
	Break
}

# SSL Certificate Handling
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# All the variables
$sstat = Get-Service -Name GsServer
$sstart = Get-WmiObject -Query "Select StartMode From Win32_Service Where Name='GsServer'"
$dl = "https://www.goodsync.com/download/GoodSync-v10-Setup.msi"
$msi = "GoodSync-v10-Setup.msi"

# Downloads GoodSync .msi to system TEMP folder, installs and removes .msi
Invoke-WebRequest -uri $dl -OutFile $env:TEMP\$msi
Start-Process msiexec.exe -Wait -ArgumentList "/I $env:TEMP\$msi /quiet"
Remove-Item $env:TEMP\$msi

# Checks for Service Status
# Stops GoodSync Service if it's running, otherwise continues
if ($sstat.status -eq "running"){
	write-output "Stopping GoodSync Server"
	stop-service gsserver
	"Service is stopped"
	"Continuing....."
	""
	}
elseif ($sstat.status -eq "stopped"){
	write-output "GoodSync Server is already Stopped"
	"continuing....."
	""
	}
# Disables GoodSync Server service
if ($sstart.startmode -ne "disabled"){
	write-output "Setting GoodSync Server service to Disabled"
	set-service gsserver -startuptype disabled
	"Done"
	}
elseif ($sstart.startmode -eq "disabled"){
	write-output "GoodSync Server service is already Disabled"
	"Done"
	}

# Removes GoodSync desktop shortcuts
Remove-Item $env:public\Desktop\GoodSync*.lnk
