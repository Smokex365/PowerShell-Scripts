#Hides Window : http://jeffwouters.nl/index.php/2015/09/howto-hide-a-powershell-prompt/
Add-Type -Name win -MemberDefinition '[DllImport("user32.dll")] public static extern bool ShowWindow(int handle, int state);' -Namespace native
[native.win]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle,0)

ForEach ($Drive in Get-PSDrive -PSProvider FileSystem) {
    $Path = $Drive.Name + ':\$RECYCLE.BIN'
    Get-ChildItem $Path -Force -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) } |
	Remove-Item -Recurse -force
	}
