#### Downloads Spiceworks and installs
####
#### Sources:
####	s1: http://nyquist212.wordpress.com/2013/09/23/powershell-webclient-example/

# s1
Function Get-Webclient ($urla, $out) {
	$proxy = [System.Net.WebRequest]::GetSystemWebProxy()
	$proxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
	$request = New-Object System.Net.WebClient
	$request.UseDefaultCredentials = $true ## Proxy credentials only
	$request.Proxy.Credentials = $request.Credentials
	$request.DownloadFile($urla, $out)
}

# Variables
$sDir = $env:userprofile
$uDir = $env:allusersprofile
$file = $sDir + "\Downloads\Spicworks.exe"
$url = "http://download.spiceworks.com/Spiceworks/current/Spiceworks.exe"

Get-Webclient $url $file
Start-Sleep -s 2

#Remove-Item $file -recurse
#start-process $sDir\ProcessExplorer\procexp.exe -ArgumentList "/AcceptEula /t" ##Accepts EULA and starts minimized
