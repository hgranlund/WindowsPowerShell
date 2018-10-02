<#
 # All functions must start with one of the approved verbs. ie. "Get", "Open", "Reset", "Find", "New", etc.
 # Use the command "Get-Verb" to get a list of all approved verbs.
 # Use a single dash ("-") to separate the verb from the command name.
 # Don't use a dash in the command name.
 #>
function Get-TemplateCommand {
    <#
    .SYNOPSIS
    This is the Get-TemplateCommand synopsis

    .DESCRIPTION
    This is the place to put the long description.

    .EXAMPLE
    Write-AllCxCmdlets

    .EXAMPLE
    You can write more examples

    #>

    # This is the place to write your awesome command :-)
    Write-Host 'Hello CxPowerShellProfile!'
}

# New commands should have a standard alias, created by combining all capitalized letters into one short word.
New-Alias -Force -Name 'gtc' -Value 'Get-TemplateCommand'

# Export your command so it's visible to the outside world.
# If you have additional private helper functions in your module, then you don't need to export them.
Export-ModuleMember -Function 'Get-TemplateCommand' -Alias 'gtc'

# In addition to creating your new module, you'll have to import it into the shared profile by adding the following to CX_UDI_Profile.ps1
# Import-Module CxTemplateModule