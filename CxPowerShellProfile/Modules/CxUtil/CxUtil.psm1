function Write-AllCxCmdlets {
    <#
    .SYNOPSIS
    Displays a list of all available Computas-made commands.

    .DESCRIPTION
    The cx command will look in all loaded modules prefixed with 'Cx', and display their functions.

    .EXAMPLE
    Write-AllCxCmdlets

    .EXAMPLE
    cx
    #>

    Get-Command -Module Cx*
}

New-Alias -Force -Name 'cx' -Value 'Write-AllCxCmdlets'
Export-ModuleMember -Function 'Write-AllCxCmdlets' -Alias 'cx'

function Debug-CxModules {
    <#
    .SYNOPSIS
    Reloads all Cx-prefixed modules with the -Verbose parameter for debugging module imports.

    .EXAMPLE
    Debug-CxModules

    .EXAMPLE
    dcm
    #>

    Get-Module -ListAvailable | Where-Object {$_.Name.StartsWith('Cx')} | Import-Module -Force -Verbose
}

New-Alias -Force -Name 'dcm' -Value 'Debug-CxModules'
Export-ModuleMember -Function 'Debug-CxModules' -Alias 'dcm'

function New-CxModule([String] $ModuleName) {
    <#
    .SYNOPSIS
    Creates a new module conforming to Cx-module standards.

    .DESCRIPTION
    New-CxModule will create a new module in the /Modules folder.

    If called without arguments, New-CxModule will prompt the user for a new module name.
    New-CxModule can also be called with the new module name as an optional argument.
    In both cases the new module name will be checked for conformity,
    and the user will be prompted if the module name is already in use.

    In order to use the command, you'll have to clone the git-repository,
    and configure your personal profile to use the profile in the local repository.

    .EXAMPLE
    New-CxModule CxExampleModule

    .EXAMPLE
    New-CxModule

    #>
    if ($CXProfilePath -eq '\\utv-hyper\Software\Computas\Powershell\CX_UDI_Profile.ps1') {
        Write-Host 'You cannot create new when using the shared profile' -ForegroundColor Red
        Write-Host 'Checkout a local copy first' -ForegroundColor Red
        return
    }

    $ModuleName = Write-PromptMissingParameter $ModuleName 'Name your module. The name must start with "Cx" (default CxTemplateModule)' 'CxTemplateModule'
    if (!$ModuleName.StartsWith('Cx')) {
        Write-Host 'Module names must start with Cx' -ForegroundColor Red
        Write-Host 'Exiting...' -ForegroundColor Red
        return
    }

    $ModuleExists = Get-Module -ListAvailable | Where-Object {$_.Name -eq $ModuleName}
    if ($ModuleExists) {
        $Warning = '{0} already exists. Are you shure you want to replace it? (Y/N)' -f $ModuleName
        $Continue
        $Continue = Write-PromptMissingParameter $Continue $Warning 'N'
        if (!($Continue -eq 'Y')) {
            return
        }
        Write-Host 'Replacing module {0}' -f $ModuleName
    }

    $NewModuleFolder = '{0}\{1}' -f $CXProfileModulePath, $ModuleName
    New-Item $NewModuleFolder -Type directory | Out-Null

    $SampleModule = '{0}\Samples\CxTemplateModule\CxTemplateModule.psm1' -f (Split-Path -Parent $CXProfilePath)
    $NewModule = '{0}\{1}.psm1' -f $NewModuleFolder, $ModuleName
    Copy-Item $SampleModule $NewModule | Out-Null

    $NewModuleCreated = 'Created new module {0}' -f $NewModule
    Write-Host $NewModuleCreated -ForegroundColor Green
}

New-Alias -Force -Name 'ncm' -Value 'New-CxModule'
Export-ModuleMember -Function 'New-CxModule' -Alias 'ncm'

function Open-Hpsm {
    <#
    .SYNOPSIS
    Open HPSM in the Chrome web browser.
    #>

    Write-Output 'Opening HPSM in Chrome...'
    chrome https://support.udi.no/hpsm/
}

New-Alias -Force -Name 'hpsm' -Value 'Open-Hpsm'
Export-ModuleMember -Function 'Open-Hpsm' -Alias 'hpsm'

function Update-Path {
    <#
    .SYNOPSIS
    Reload enviroment variables.

    .DESCRIPTION
    The Update-Path command will reload env:path.
    #>

    Write-Output 'Reloading env:path'
    $env:Path = [System.Environment]::GetEnvironmentVariable('Path','Machine')
}

New-Alias -Force -Name 'up' -Value 'Update-Path'
Export-ModuleMember -Function 'Update-Path' -Alias 'up'

function Uninstall-Program([String] $name){
    <#
    .SYNOPSIS
    Uninstalls a program with a given name
    #>

    $app = Get-WmiObject -Class Win32_Product | Where-Object {
        $_.Name -match $name
    }

    $app.Uninstall()
}

New-Alias -Force -Name 'upr' -Value 'Uninstall-Program'
Export-ModuleMember -Function 'Uninstall-Program' -Alias 'upr'

function Grant-ModifyTo([String] $rootFolder, [String] $user) {
    <#
    .SYNOPSIS
    Grant access-level 'Modify' on a given folder, contents and sub-folders to a given user.

    .DESCRIPTION
    A user is given on the format domain\username. If a user is not spesified, 'Everyone' will be used.

    .EXAMPLE
    Grant-ModifyTo C:\DUFTEMP UTV\tret

    .EXAMPLE
    Grant-ModifyTo C:\DUFTEMP
    #>

    if($user -eq '') {
        $user = 'Everyone'
    }

    $items = Get-ChildItem $rootFolder
    $inheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
    $propagationFlag = [System.Security.AccessControl.PropagationFlags]::None
    $objType = [System.Security.AccessControl.AccessControlType]::Allow

    $acl = Get-Acl $rootFolder
    $permission = $user, 'Modify', $inheritanceFlag, $propagationFlag, $objType
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission

    $acl.SetAccessRule($accessRule)
    Set-Acl $rootFolder $acl

    Foreach ($item in $items)
    {
        $folder = Join-Path $rootFolder $item
        if ((Get-Item $folder) -is [System.IO.DirectoryInfo]) {
            Grant-ModifyTo $folder $user   
        }
    }
}

New-Alias -Force -Name 'gmt' -Value 'Grant-ModifyTo'
Export-ModuleMember -Function 'Grant-ModifyTo' -Alias 'gmt'

function Get-DevBranches {
    <#
    .SYNOPSIS
    Get a list of development-branches and their corresponding development environments.

    .DESCRIPTION
    The content of the list is based on \\udi-u-v-dufc1\DufClient\settings.xml. This is also the data-source used by DufCentral.

    .EXAMPLE
    Get-DevBranches
    #>

    [xml]$utv = Get-Content \\udi-u-v-dufc1\DufClient\settings.xml

    ForEach ($item in $utv.root.item)
    {
        $note = $item.note
        $version = $item.version
        if($version -like '--*')
        {
            $text = '{0}: {1}' -f ($version -replace '-', '').Trim(), $note
            Write-Host $text -ForegroundColor Green
        }
    }
}

New-Alias -Force -Name 'gdb' -Value 'Get-DevBranches'
Export-ModuleMember -Function 'Get-DevBranches' -Alias 'gdb'

function Write-PromptMissingParameter ([String] $Param, [String] $Prompt, [String] $Default) {
    <#
    .SYNOPSIS
    Utility-function for prompting users for required parameters

    .EXAMPLE
    Have a look at Reset-UdbPassword in the module CxSqlUtil.
    #>

    if($Param -eq '') {
        $Result = Read-Host $Prompt
        if($Result -eq '') {
            return $Default
        }
        else {
            return $Result
        }
    }
    return $Param
}

Export-ModuleMember -function Write-PromptMissingParameter
