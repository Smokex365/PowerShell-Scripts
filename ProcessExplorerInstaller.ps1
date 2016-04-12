#### Downloads Process explorer from download.sysinternals.com,
#### unzips it into Program Files and then cleans up.
####
#### Sources:
####	s1: http://nyquist212.wordpress.com/2013/09/23/powershell-webclient-example/
####	s2: http://sharepoint.smayes.com/2012/07/extracting-zip-files-using-powershell/

#Checks for Administrator priveleges and opens an elevated prompt is user has Administrator rights
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
	$arguments = "& '" + $myinvocation.mycommand.definition + "'"
	Start-Process powershell -Verb runAs -ArgumentList $arguments
	Break
}

# s1 
Function Get-Webclient ($urla, $out) {
	$proxy = [System.Net.WebRequest]::GetSystemWebProxy()
	$proxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
	$request = New-Object System.Net.WebClient
	$request.UseDefaultCredentials = $true ## Proxy credentials only
	$request.Proxy.Credentials = $request.Credentials
	$request.DownloadFile($urla, $out)
}

# s2 

# Expands the entire contents of a zip file to a folder
# MSDN References
# - Shell Object:   http://msdn.microsoft.com/en-us/library/windows/desktop/bb774094(v=vs.85).aspx
# - SHFILEOPSTRUCT: http://msdn.microsoft.com/en-us/library/windows/desktop/bb759795(v=vs.85).aspx
function Expand-Zip (
    [ValidateNotNullOrEmpty()][string]$ZipFilePath,
    [ValidateNotNullOrEmpty()][string]$DestinationFolderPath,
    [switch]$HideProgressDialog,
    [switch]$OverwriteExistingFiles
) {
    # Ensure that the zip file exists, the destination path is a folder, and the destination folder
    # exists. The code to expand the zip file will *only* execute if the three conditions above are
    # true.
    if ((Test-Path $ZipFilePath) -and (Test-Path $DestinationFolderPath) -and ((Get-Item $DestinationFolderPath).PSIsContainer)) {
        try {
            # Configure the flags for the copy operation based on the switches passed to this
            # function. The flags for the CopyHere method are based on the SHFILEOPSTRUCT
            # structure's fFlags field. Two of the flags are leveraged by this function.
            # 0x04 --- Do not display a progress dialog box.
            # 0x10 --- Click "Yes to All" in any dialog box displayed. Functionally overwrites any
            #          existing files.
            $copyFlags = 0x00
            if ($HideProgressDialog) {
                $copyFlags += 0x04
            }
            if ($OverwriteExistingFiles) {
                $copyFlags += 0x10
            }
            
            # Create the Shell COM object
            $shell = New-Object -ComObject Shell.Application
            
            # Get references to the zip file and the destination folder as Shell Folder COM objects
            $zipFile = $shell.NameSpace($ZipFilePath)
            $destinationFolder = $shell.NameSpace($DestinationFolderPath)
            
            # Execute a file copy from the zip file to the destination folder; which effectively
            # extracts the zip file's contents to the destination folder
            $destinationFolder.CopyHere($zipFile.Items(), $copyFlags)
        } finally {
            # Release the COM objects
            if ($zipFile -ne $null) {
                [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($zipFile)
            }
            if ($destinationFolder -ne $null) {
                [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($destinationFolder)
            }
            if ($shell -ne $null) {                
                [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($shell)
            }
        }
    }
}

function mkdirs {
	mkdir $sDir\temp\ -force > $null
	mkdir $sDir\ProcessExplorer\ -force > $null
    mkdir "$start\Process Explorer" -force > $null
}

function shortcuts ($target, $link) {
	# Create a Shortcut with Windows PowerShell
	$TargetFile = $target
	$ShortcutFile = $link
	$WScriptShell = New-Object -ComObject WScript.Shell
	$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
	$Shortcut.TargetPath = $TargetFile
	$Shortcut.Save()
	}

# Variables
$sDir = $env:programfiles
$uDir = $env:allusersprofile
$start = [Environment]::GetFolderPath('CommonStartMenu') + "\Programs\Process Explorer"
$url = "http://download.sysinternals.com/files/ProcessExplorer.zip"
$file = $sDir + "\temp\ProcessExplorer.zip"

# Makes directories:
# ProcessExplorer directory in Program Files according to Environment variable\
# temp directory in Program Files for download
mkdirs
Get-Webclient $url $file
Start-Sleep -s 2
# Closes Process Explorer if running
# Get-Process procexp* | stop-process –force
Expand-Zip $file "$sDir\ProcessExplorer\" -HideProgressDialog -OverwriteExistingFiles
Remove-Item "$sDir\temp\" -recurse
# Creates Start Menu shorcuts
shortcuts "$sDir\ProcessExplorer\Eula.txt" "$start\EULA.lnk"
shortcuts "$sDir\ProcessExplorer\procexp.chm" "$start\Process Explorer Help.lnk"
shortcuts "$sDir\ProcessExplorer\procexp.exe" "$start\Process Explorer.lnk"
# Accepts EULA and starts minimized
start-process $sDir\ProcessExplorer\procexp.exe -ArgumentList "/AcceptEula /t" 
