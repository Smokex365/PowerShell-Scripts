$packages = (
    #3D Builder:
    "3dbuilder",
    #Alarms and Clock: 
    #"alarms",
    #Calculator: 
    #"calculator",
    #Calendar and Mail: 
    "communications",
    #Camera: 
    "camera",
    #Get Office: 
    "officehub",
    #Get Skype: 
    "skypeapp",
    #Get Started: 
    "getstarted",
    #Groove Music: 
    "zunemusic",
    #Maps: 
    "maps",
    #Microsoft Solitaire Collection: 
    #"solitairecollection",
    #Money: 
    "bingfinance",
    #Movies & TV: 
    "zunevideo",
    #News: 
    "bingnews",
    #OneNote: 
    "onenote",
    #People: 
    "people",
    #Phone Companion: 
    "windowsphone",
    #Photos: 
    #"photos",
    #Sports: 
    "bingsports",
    #Voice Recorder: 
    "soundrecorder",
    #Weather: 
    #"bingweather",
    #Xbox: 
    #"xbox",
    #Sway
    "sway"
    )

foreach ($apps in $packages) {   
    Get-AppxPackage $appx | Remove-AppxPackage
}