if(Test-Path $profile_modules_path){
  Get-ChildItem $profile_modules_path *.psm1 | foreach{
    Import-Module $_.FullName
  }
}

