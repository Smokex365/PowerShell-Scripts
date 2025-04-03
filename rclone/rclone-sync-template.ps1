$td = Get-Date -uformat "%Y-%m-%d_%H%M%S"
$log=$env:userprofile+"\.rclone\logs\dir\sync_["+$td+"].log"
$logdir = $env:userprofile+"\.rclone\logs\dir"

#cleans logs
function cleanup {
    Get-ChildItem $logdir -Force -Recurse -ErrorAction SilentlyContinue |
    Where-Object { 
        ($_.LastWriteTime -lt (Get-Date).AddDays(-30))
    } |
	Remove-Item -Recurse -Force
}

#rclone options parameter array
$params = (
    "--checkers=16",
    "--transfers=8",
    "--verbose=1",
    "--contimeout=60s",
    "--timeout=300s",
    "--low-level-retries=10",
    "--log-file=$log",
    "--filter-from=$env:filter\filter_exclude",
    "--backup-dir=dir/.rc-backup/dir/sync_[$td]",
    "--fast-list",
    "--progress",
    "--stats=1s",
    "--verbose=1"#,
    #"--dry-run"
    )
$rarg = $params.Replace("\t|\r|\n","")
cleanup

rclone sync $rarg "source" "destination"
