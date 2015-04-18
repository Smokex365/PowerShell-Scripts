ForEach ($Drive in Get-PSDrive -PSProvider FileSystem) {
    $Path = $Drive.Name + ':\$RECYCLE.BIN'
    Get-ChildItem $Path -Force -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) } |
	Remove-Item -Recurse -force
	}
