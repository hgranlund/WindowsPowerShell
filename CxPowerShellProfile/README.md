CxPs - Computas PowerShell Profile
==================================

_A place to share PowerShell-scripts with Computas@UDI_

### Installation:

__For beginners:__

1. Start Powershell as administrator, and run `Set-ExecutionPolicy bypass`
2. Copy the folder `\Samples\WindowsPowerShell` and its contents to `C:\Users\<your username>\Documents\`. After copying you should have the following folder-structure: `C:\Users\<your username>\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`. You can download `\Samples\WindowsPowerShell` by clicking on the "Samples"-folder in the left menu, hover the cursor over "WindowsPowerShell", press on the three dots that appear and select "Download as zip".
3. Start PowerShell (Windows + R, type powershell and press enter)
4. Verify your installation by running the comman `cx` in the PowerShell window. You should se an output similiare to the listing under

Sample listing:

    > cx

    CommandType     Name                                               ModuleName
    -----------     ----                                               ----------
    Function        build                                              CxVisualStudio
    Function        Convert-FileEncoding                               CxGet-FileEncoding
    Function        Create-ChocolateyPackageFromMsi                    CxChocolatey

__For advanced users:__

Add the following to your own profile:

    . '\\utv-hyper\Software\Computas\Powershell\CX_UDI_Profile.ps1'


### How to use the shared profile:

The command `cx [name of command]` will list all commands in the shared profile.

Use `Get-Help` to find out more about any command:

    > Get-Help Open-Solution

    NAME
        Open-Solution

    SYNOPSIS
        Lists and opens sulution found recursively in current folder.
     
    ...

Use `Get-Help -Full [name of command]` to find out even more about any command, including examples of use:

    > Get-Help -Full Open-Norvis

    NAME
        Open-Norvis

    SYNOPSIS
        Open Norvis for a given UTV-environment.

    SYNTAX
        Open-Norvis [[-Environment] <String>] [<CommonParameters>]


    DESCRIPTION
        The Norvis command will open Norvis, given it is already installed at "C:\Program Files (x86)\Norvis\".
        If Norvis is not installed, consider installing it with Chocolatey e.g. "choco install NorvisUTV02".

    OUTPUTS

        -------------------------- EXAMPLE 1 --------------------------

        C:\PS>Open-Norvis


### Contributing:

Please contribute to the shared profile :-)

__Requirements:__

* Git

__Developer installation:__

* `cd C:\Some\Folder\For\Git\Projects`
* `git clone http://tfs:8080/tfs/DefaultCollection/FUS/_git/CxPowerShellProfile`
* Configure your `C:\Users\<your username>\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` to use the cloned version of CxPowerShellProfile as shown under.

```
# Load shared profile
# . '\\utv-hyper\Software\Computas\Powershell\CX_UDI_Profile.ps1' <- This is commented out

# Load development profile
. 'C:\<your path to local git repo>\CxPowerShellProfile\CX_UDI_Profile.ps1' # <- This is commented in
```

__Some tips for creating a awesome shared commands:__

* A command should not be user-spesific, ie. no Users\tael\My\Super\Custom\Path\myVeryPersonalProgramToAlias.exe
* A command should only depend on software that used on all development images ie. DufCentralClientUIProj.exe, og software that is contained within the profile ie. MyCustomScript.exe
* Is tested by you after adding it to the shared profile (Kudos to the first contributer that introduces automated tests!)
* Include Get-Help text in your shared commands, and it's much easier to use later.


### How to create your first shared command

__1 - Create a new module for your new command (or find a suitable existing module)__

If you already know there exists a suitable module for your new command you can skip this section,
but more often than not you'll want to create a new module, in order to not overcrowd existing modules.

You can use the command `New-CxModule` to create a new module. This cmdlet will guide you through creating a new module that conforms to Cx-profile standards.

After the module is created, run the command `Import-CxModules` to reload all modules and register the new module.
Now you can try out the template command `Get-TemplateCommand`.

If you want to create the module manually, without `Import-CxModules`, the \Samples folder contains a template module to get you started with your first command.
* Copy the folder `\Samples\CxTemplateModule` and its contents into `\Modules`.
* Run the command `Import-CxModules` to reload all modules and register the new module.
* Now you can try out the template command `Get-TemplateCommand`.

Next you'll want to rename the sample module with a more suitable name. When naming new modules it's important to remember the following:
* All module names must start with Cx.
* The module folder and the module file (the .psm1 file) must have the same name.

_Tips:_ If your module fails to load, use `Debug-CxModules` to debug all failing imports.

__2 - Write your new command__

The template module includes a template command named `Get-TemplateCommand`. This can be used as a skeleton for your own command.

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

__3 - Handeling input parameters__

Input can be handled in several different ways, but the easiest is ofthen to use PowerShell's built in parameter syntax:

    function Invoke-UdbQuery ([String] $Query, [String] $Database) { ... }

This spesifies that `Invoke-UdbQuery` accepts two parameters, and bind their input values to two String variables named `$Query` and `$Database`.

__4 - Accessing UDB__

The module CxUdb contains functions intended to make it easier to write commands that query UDB. The functions require that the assembly System.Data.OracleClient is present on the users machine (supplied and installed with regular Oracle clients).

__5 - Parsing XML__

Windows loves XML ([citation needed](http://tfs:8080/tfs/DefaultCollection/FUS/_git/CxPowerShellProfile?path=%2FREADME.md&version=GBmaster&_a=contents)), so XML is quite easy to parse in PowerShell.

Under is an example from `Get-DevBranches` in the module CxUtil:

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

__6 - Check in your changes__

When you're happy with your new command, check in your changes and push to the remote repository

    > git add [your changed files]
    > git commit -m "This is my new command"
    > git push origin master

This will trigger the build CxPowerShellProfile, and the build will distribute the changes to all the Computas@UDI developers.
