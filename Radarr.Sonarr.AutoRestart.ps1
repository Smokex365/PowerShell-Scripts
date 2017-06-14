#Checks for Administrator privileges and opens an elevated prompt is user has Administrator rights
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
	$arguments = "& '" + $myinvocation.mycommand.definition + "'"
	Start-Process powershell -Verb runAs -ArgumentList $arguments
	Break
}
# https://darshanaj.wordpress.com/2012/04/08/powershell-script-for-start-the-multiple-services-if-stopped/
$srvservice=Get-Service
$counter
$counter=1
foreach($service in $srvservice)
	{
		if ($srvservice[$counter].name -eq "Radarr" -or
			$srvservice[$counter].name -eq "NzbDrone")
			{
			if ($srvservice[$counter].status -eq
				"stopped"
			)
		{
		start-service -name	$srvservice[$counter].name
	}
 }
$counter++
}