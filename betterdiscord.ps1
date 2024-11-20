#https://github.com/BetterDiscord/cli/releases

$arguments = (
    #uncomment the versions you wish to use 
    "install stable",
    #"install canary"
    #"install ptb"
)

$bdcli = "bdcli.exe"
$bdclidir = "bdcli\directory"

ForEach ($cmd in $arguments) {
    Start-Process -filepath $bdclidir\$bdcli -ArgumentList $cmd
}
