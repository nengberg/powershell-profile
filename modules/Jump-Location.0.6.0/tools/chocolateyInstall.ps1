$name   = "Jump-Location"
$url    = "https://sourceforge.net/projects/jumplocation/files/latest/download"
$unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Install-ChocolateyZipPackage $name $url $unzipLocation

$installer = Join-Path $unziplocation 'Install.ps1'
& $installer