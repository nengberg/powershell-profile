Import-Module 'C:\tools\poshgit\dahlbyk-posh-git-a4faccd\src\posh-git.psd1'
Import-Module 'C:\Program Files\WindowsPowerShell\Modules\Jump.Location\0.6.0\Jump.Location.psd1'

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

function touch {set-content -Path ($args[0]) -Value ($null)}
function Get-Hosts{ start-process -verb RunAs notepad++ C:\Windows\System32\Drivers\etc\hosts }

function git-cleanup { 
	git branch --merged | ?{(-not ($_.trim() -like "master")) -and (-not ($_.trim() -like "develop")) -and (-not $_.trim().StartsWith("*"))} | %{git branch -d $_.trim()}
	git fetch -p
}


Set-Location -Path C:\Projects