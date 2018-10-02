Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Load shared profile
. 'C:\Users\nosigra\Documents\WindowsPowerShell\CxPowerShellProfile\CX_Profile.ps1'
# Load development profile
# . 'C:\[YOUR_PATH_TO_GIT_REPO]\CxPowerShellProfile\CX_UDI_Profile.ps1'

# Load shared profile

Import-Module 'C:\tools\poshgit\dahlbyk-posh-git-9bda399\src\posh-git.psd1'

if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadLine
}

function note () {
    code C:\depot\note\;
}

function depot() {
    cd c:/depot
}
function depot() {
    cd c:/depot/timseries-api
}