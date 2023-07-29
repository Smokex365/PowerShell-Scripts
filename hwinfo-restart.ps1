$hwinfo = "HWiNFO64"
$hwinfopath = "C:\Program Files\HWiNFO64\HWiNFO64.EXE"

for(;;){
    try{
        If (!(Get-Process -ProcessName $hwinfo -ErrorAction SilentlyContinue))
            {Invoke-Item $hwinfopath}
            $proc = Get-Process -ProcessName $hwinfo | Sort-Object -Property ProcessName -Unique -ErrorAction SilentlyContinue
        If (!$proc -or ($proc.Responding -eq $false) -or ($proc.StartTime -lt (Get-Date).AddHours(-8))) {
            $proc.Kill()
            Start-Sleep -s 10
            Invoke-Item $hwinfopath}
        }
    catch    {    }
    Start-sleep -s 300
}