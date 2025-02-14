$td = Get-Date -uformat "%Y-%m-%d_%H%M%S"
$log = $env:userprofile+"\.rclone\logs\onedrive-mount\onedrive-mount_["+$td+"].log"
$logdir = $env:userprofile+"\.rclone\logs\onedrive-mount"
$mount = "mounted-drive-letter:"

function cleanup {
    Get-ChildItem $logdir -Force -Recurse -ErrorAction SilentlyContinue |
    Where-Object { 
        ($_.LastWriteTime -lt (Get-Date).AddDays(-30)) `
        -or ( `
            ($_.LastWriteTime -lt (Get-Date).AddDays(-14)) `
            -and (Get-ChildItem -Filter "*.log" -Recurse -File | Where-Object Length -lt 2kb) `
        ) 
    } |
	Remove-Item -Recurse -Force
}

$params = @(
    "--verbose=1",
    "--log-file=$log",
    "--vfs-cache-mode=full",
    "--links"
)

$rarg = $params.Replace("\t|\r|\n","")
cleanup

for (;;) {
    try {
        $drive_stat = Get-PSDrive -PSProvider FileSystem | Where-Object {$_.Name -eq "O"}
        if ($drive_stat) {
            Start-Sleep -Seconds (60*30)
        }
        else {
            rclone mount onedrive-smokex365: $mount $rarg
        }
    }
    catch {
        rclone mount onedrive-smokex365: $mount $rarg
    }
    Start-Sleep -Seconds (60*30)
}
