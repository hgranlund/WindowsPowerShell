Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Load shared profile
. '\\utv-hyper\Software\Computas\Powershell\CX_UDI_Profile.ps1'

# Load development profile
# . 'C:\[YOUR_PATH_TO_GIT_REPO]\CxPowerShellProfile\CX_UDI_Profile.ps1'
         
set-alias -name ll -value "ls"
set-alias -name subl -value "C:\Program Files\Sublime Text 3\sublime_text.exe"
