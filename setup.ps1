function Install($module) {
    if (Get-Module -ListAvailable -Name $module) {
        Write-Host "$module already installed. Not installing."
    } else {
        Write-Host "$module not installed. Installing"
        Install-Module $module
    }
}

function SymLink($link, $target) {
    cmd /c mklink /h $link $target
}

Install "Jump.Location"

SymLink "C:\Program Files\ConEmu\ConEmu.xml" "C:\powershell-profile\ConEmu.xml"
SymLink $PROFILE "C:\powershell-profile\Microsoft.PowerShell_profile.ps1"