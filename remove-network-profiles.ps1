# This scripts removes unused Network Profiles in Windows based on either connected status
# or connected status + a network name. Should be run from a elevated PowerShell prompt.
# Run with the -whatif option on line 29 to check for unintended actions.
# Only tested on Windows 10 but should work on Windows 11 and/or Windows Server 2016/2019/2022/2025.

# Import the necessary modules
Import-Module Microsoft.PowerShell.Management

# Get the string to search for
#$network = ""

# Get all registry keys and values
$registryItems = Get-ChildItem -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles" -ErrorAction SilentlyContinue

# Loop through the registry items
foreach ($registryItem in $registryItems) {

    # Get the GUID of the registry item
    $guid = $registryItem.PSChildName

    #check if the registry item is connected
    $connected = $registryItem.GetValue("Category")

    # Check if the value contains the search context
    # $connected currently checks for networks connected status
    # 0 for disconnected, 1 for connected, 2 for metered
    if ($connected -like 0) {
    #if ($connected -like 0 -and $value -like $network) {
        # Remove the registry entry
        remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles\$guid" #-whatif
    }
}
