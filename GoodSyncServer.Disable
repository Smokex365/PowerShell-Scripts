$sstat = Get-Service -Name GsServer
$sstart = Get-WmiObject -Query "Select StartMode From Win32_Service Where Name='GsServer'"
#Checks for Service Status
#Stops GoodSync Service if it's running, otherwise continues
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
if ($sstart.startmode -ne "disabled"){
	write-output "Setting GoodSync Server service to Disabled"
	set-service gsserver -startuptype disabled
	"Done"
	}
elseif ($sstart.startmode -eq "disabled"){
	write-output "GoodSync Server service is already Disabled"
	"Done"
	}
