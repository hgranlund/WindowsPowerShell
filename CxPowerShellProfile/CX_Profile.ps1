# Add module location to path
$CXProfilePath = $MyInvocation.MyCommand.Definition
$CXProfileModulePath = '{0}\Modules' -f (Split-Path -Parent $CXProfilePath)
$env:PSModulePath = '{0};{1}' -f $env:PSModulePath, $CXProfileModulePath

# Function for updating all Cx-modules
# Intended for development
# ImportCxModules is placed here due to problems with reloading modules from functions inside of modules
function Import-CxModules {
    Write-Host 'Importing all Cx-modules...'
    Get-Module -ListAvailable | Where-Object {$_.Name.StartsWith('Cx')} | Import-Module -Force
}

# Import all modules starting with Cx
# Use Debug-CxModules to debug failing imports
Import-CxModules

# Aliases
Set-Alias -Name ll -Value 'ls'
Set-Alias -Name chrome -Value 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'
Set-Alias -Name grep -Description grep Select-String

# Drives
# New-PSDrive sp filesystem \\server\SP

function depot() {
    cd c:/depot
}