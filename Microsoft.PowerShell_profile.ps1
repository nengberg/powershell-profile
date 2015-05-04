#Set HOME path

(get-psprovider 'FileSystem').Home = 'C:\Users\nengberg'
Remove-Variable -Force HOME
$global:home = (resolve-path ~)
set-location ~

$customModulesPath = resolve-path ~/Documents/WindowsPowerShell/modules/
$jumpLocation = join-path $customModulesPath Jump-Location.0.6.0/tools/Jump.Location.psd1

# Load Pshazz
try { $null = gcm pshazz -ea stop; pshazz init } catch { }

# Load Jump-Location profile
Import-Module $jumpLocation

New-Alias -name locate -value "C:\Users\nengberg\AppData\Local\locate\Invoke-Locate.ps1" -scope Global -force
New-Alias -name updatedb -value "C:\Users\nengberg\AppData\Local\locate\Update-LocateDB.ps1" -scope Global -force
Set-Alias np "C:\Program Files (x86)\Notepad++\notepad++.exe"
Set-Alias ssh-agent "${env:ProgramFiles(x86)}\git\bin\ssh-agent.exe"
Set-Alias ssh-add "${env:ProgramFiles(x86)}\git\bin\ssh-add.exe"
Set-Alias go checkout-git-branch
Set-Alias goo checkout-new-git-branch

function git-cleanup {
	git branch --merged | ?{(-not ($_.trim() -like "master")) -and (-not ($_.trim() -like "develop")) -and (-not $_.trim().StartsWith("*"))} | %{git branch -d $_.trim()}
}

function Get-Hosts{
	start-process -verb RunAs notepad++ C:\Windows\System32\Drivers\etc\hosts
}

function checkout-git-branch($branch) { git checkout $branch }
