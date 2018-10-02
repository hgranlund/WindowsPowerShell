
Import-Module 'C:\tools\poshgit\dahlbyk-posh-git-9bda399\src\posh-git.psd1'

if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadLine
}

# Load shared profile
function Load_Cx {
    & 'CxPowerShellProfile\CX_Profile.ps1'
}

function note () {
    code C:\depot\note\;
}