$modules = "C:\Program Files\WindowsPowerShell\Modules"

Import-Module 'C:\tools\poshgit\dahlbyk-posh-git-a4faccd\src\posh-git.psd1'
Import-Module "C:\Program Files\WindowsPowerShell\Modules\Jump.Location\0.6.0\Jump.Location.psd1"

# Background colors
$baseBackgroundColor = "Black"
$GitPromptSettings.AfterBackgroundColor = $baseBackgroundColor
$GitPromptSettings.AfterStashBackgroundColor = $baseBackgroundColor
$GitPromptSettings.BeforeBackgroundColor = $baseBackgroundColor
$GitPromptSettings.BeforeIndexBackgroundColor = $baseBackgroundColor
$GitPromptSettings.BeforeStashBackgroundColor = $baseBackgroundColor
$GitPromptSettings.BranchAheadStatusBackgroundColor = $baseBackgroundColor
$GitPromptSettings.BranchBackgroundColor = $baseBackgroundColor
$GitPromptSettings.BranchBehindAndAheadStatusBackgroundColor = $baseBackgroundColor
$GitPromptSettings.BranchBehindStatusBackgroundColor = $baseBackgroundColor
$GitPromptSettings.BranchGoneStatusBackgroundColor = $baseBackgroundColor
$GitPromptSettings.BranchIdenticalStatusToBackgroundColor = $baseBackgroundColor
$GitPromptSettings.DelimBackgroundColor = $baseBackgroundColor
$GitPromptSettings.IndexBackgroundColor = $baseBackgroundColor
$GitPromptSettings.ErrorBackgroundColor = $baseBackgroundColor
$GitPromptSettings.LocalDefaultStatusBackgroundColor = $baseBackgroundColor
$GitPromptSettings.LocalStagedStatusBackgroundColor = $baseBackgroundColor
$GitPromptSettings.LocalWorkingStatusBackgroundColor = $baseBackgroundColor
$GitPromptSettings.StashBackgroundColor = $baseBackgroundColor
$GitPromptSettings.WorkingBackgroundColor = $baseBackgroundColor

# Foreground colors
$GitPromptSettings.AfterForegroundColor = "Blue"
$GitPromptSettings.BeforeForegroundColor = "Blue"
$GitPromptSettings.BranchForegroundColor = "Blue"
$GitPromptSettings.BranchGoneStatusForegroundColor = "Blue"
$GitPromptSettings.BranchIdenticalStatusToForegroundColor = "White"
$GitPromptSettings.DefaultForegroundColor = "Gray"
$GitPromptSettings.DelimForegroundColor = "Blue"
$GitPromptSettings.IndexForegroundColor = "Green"
$GitPromptSettings.WorkingForegroundColor = "Yellow"

# Prompt shape
$GitPromptSettings.AfterText = ""
$GitPromptSettings.BeforeText = "  "
$GitPromptSettings.BranchAheadStatusSymbol = ""
$GitPromptSettings.BranchBehindStatusSymbol = ""
$GitPromptSettings.BranchBehindAndAheadStatusSymbol = ""
$GitPromptSettings.BranchGoneStatusSymbol = ""
$GitPromptSettings.BranchIdenticalStatusToSymbol = ""
$GitPromptSettings.DelimText = " ॥"
$GitPromptSettings.LocalStagedStatusSymbol = ""
$GitPromptSettings.LocalWorkingStatusSymbol = ""
$GitPromptSettings.ShowStatusWhenZero = $false

######## PROMPT

set-content Function:prompt {
  $title = (get-location).Path.replace($home, "~")
  $idx = $title.IndexOf("::")
  if ($idx -gt -1) { $title = $title.Substring($idx + 2) }

  $windowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  $windowsPrincipal = new-object 'System.Security.Principal.WindowsPrincipal' $windowsIdentity
  if ($windowsPrincipal.IsInRole("Administrators") -eq 1) { $color = "Red"; }
  else { $color = "Green"; }

  $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

  if ($LASTEXITCODE -ne 0) {
      write-host " " -NoNewLine
      write-host "  $LASTEXITCODE " -NoNewLine -BackgroundColor DarkRed -ForegroundColor Yellow
  }

  if ($PromptEnvironment -ne $null) {
      write-host " " -NoNewLine
      write-host $PromptEnvironment -NoNewLine -BackgroundColor DarkMagenta -ForegroundColor White
  }
  
  if ((get-location -stack).Count -gt 0) {
    write-host " " -NoNewLine
    write-host (Split-Path -leaf -path (Get-Location)) -NoNewLine -ForegroundColor $color
  }

  if (Get-GitStatus -ne $null) {
      write-host " " -NoNewLine
      Write-VcsStatus
  }

  $global:LASTEXITCODE = 0

  write-host " " -NoNewLine
  write-host ">" -NoNewLine -ForegroundColor $color

  $host.UI.RawUI.WindowTitle = $title
  return " "
}

function touch {
    set-content -Path ($args[0]) -Value ($null)
}

function get-hosts { 
    start-process -verb RunAs notepad++ C:\Windows\System32\Drivers\etc\hosts
}

function git-cleanup { 
	git branch --merged | ?{(-not ($_.trim() -like "master")) -and (-not ($_.trim() -like "develop")) -and (-not $_.trim().StartsWith("*"))} | %{git branch -d $_.trim()}
	git fetch -p
}

function vs {
    $vsPath = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\devenv.exe";
    if ($args.length -gt 0) {
        start-process -verb RunAs $vsPath $args[0]
    } else {
        start-process -verb RunAs $vsPath
    }
    
}

function iis {
    start-process -verb RunAs "C:\WINDOWS\system32\inetsrv\InetMgr.exe"
}

function start-docker {
    start-process -verb RunAs "C:\Program Files\Docker\Docker\Docker for Windows.exe"
}

function profile {
    code C:\powershell-profile\Microsoft.PowerShell_profile.ps1
}

###### Docker aliases

function Get-Containers-Formatted {
    docker ps --format '{{.ID}} ~ {{.Names}} ~ {{.Status}} ~ {{.Image}}'
}

function Remove-DanglingImages {
	foreach ($id in & docker images -q -f 'dangling=true') { 
		& docker rmi $id }
}

function Remove-ExitedContainers {
	foreach ($id in & docker ps -qa --no-trunc --filter 'status=exited') { 
		& docker rm $id }
}

New-Alias dkps Get-Containers-Formatted
New-Alias drmi Remove-DanglingImages
New-Alias drmec Remove-ExitedContainers
New-Alias dk docker
New-Alias dkc docker-compose

###### K8s aliases

function ExecKube($resource, $namespace) {
    if($namespace) {
        kubectl get $resource --field-selector metadata.namespace=$namespace --all-namespaces
    } else {
        kubectl get $resource --all-namespaces
    }
}

function ksvcs {
    ExecKube -resource 'services' -namespace $args[0]
}

function kpods {
    ExecKube -resource 'pods' -namespace $args[0]
}

function kings {
    ExecKube -resource 'ingresses' -namespace $args[0]
}

function kdeps {
    ExecKube -resource 'deployments' -namespace $args[0]
}

Set-Alias k kubectl

Set-Location -Path C:\Projects