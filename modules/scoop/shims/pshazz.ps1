# ensure $HOME is set for MSYS programs
if(!$env:home) { $env:home = "$home\" }
if($env:home -eq "\") { $env:home = $env:allusersprofile }
$path = "C:\Users\nengberg\Documents\WindowsPowerShell\modules\scoop\apps\pshazz\0.2014.11.25\bin\pshazz.ps1"
if($myinvocation.expectingInput) { $input | & $path @args } else { & $path @args }
