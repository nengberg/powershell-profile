# ensure $HOME is set for MSYS programs
if(!$env:home) { $env:home = "$home\" }
if($env:home -eq "\") { $env:home = $env:allusersprofile }
$path = "C:\users\nengberg\Documents\WindowsPowerShell\modules\scoop\apps\scoop\current\bin\scoop.ps1"
if($myinvocation.expectingInput) { $input | & $path @args } else { & $path @args }
