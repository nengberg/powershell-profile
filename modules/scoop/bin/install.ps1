
# get core functions
$core_url = $global:home.path + '\Documents\WindowsPowerShell\modules\scoop\lib\core.ps1';
echo 'initializing...';
iex (new-object net.webclient).downloadstring($core_url)

# prep
if(installed 'scoop') {
	write-host "scoop is already installed. run 'scoop update' to get the latest version." -f red
	# don't abort if invoked with iex——that would close the PS session
	if($myinvocation.commandorigin -eq 'Internal') { return } else { exit 1 }
}
$dir = ensure (versiondir 'scoop' 'current')

echo 'creating shim...'
shim $global:home.path + '\Documents\WindowsPowerShell\modules\scoop\bin\scoop.ps1' $false
$env:path += ';' + $global:home.path + '\WindowsPowerShell\modules\scoop\shims'
ensure_scoop_in_path
success 'scoop was installed successfully!'
echo "type 'scoop help' for instructions"
