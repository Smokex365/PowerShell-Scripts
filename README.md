
PowerShell-Scripts

==================
A assortment of various PowerShell Scripts either functional or a WiP

ProcessExplorerInstaller.ps1

Downloads and installs Sysinternals Process Explorer (defaults to Program Files). Largely replaced by chocolatey and winget but still useful for systems that can't install those tools.

RandomAlphanumericStringToClipboard.ps1

Generates a random alphanumeric string of the specified length and copies it to the clipboard.

hwinfo-restart.ps1

A simple looping script to restart hwinfo every 8 hours to bypass the free 12 hour limit for shared memory access. Cheap workaround for an application that really didn't warrant a full license.

remove-network-profiles.ps1

This scripts removes unused Network Profiles in Windows based on either connected status or connected status + a network name. Should be run from a elevated PowerShell prompt. Run with the -whatif option on line 29 to check for unintended actions. Only tested on Windows 10 but should work on Windows 11 and/or Windows Server 2016/2019/2022/2025.
