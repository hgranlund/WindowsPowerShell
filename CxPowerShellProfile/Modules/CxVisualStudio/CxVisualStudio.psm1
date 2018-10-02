
function build() {
    <#
    .SYNOPSIS
    Build all C# projects in the current folder.

    .DESCRIPTION
    Four cores is used when running the build.

    .EXAMPLE
    build
    #>

    Write-Output "Building solution with p=4"
    msbuild /m:4
}

Export-ModuleMember -Function 'build'

function Search-BinDebug {
    <#
    .SYNOPSIS
    Search all \bin\debug -files.
    #>

    ls -r -filter "*.csproj" | select-String "(<HintPath>).*(bin\\Debug).*(HintPath>)$" -AllMatches;
}

New-Alias -Force -Name 'sbd' -Value 'Search-BinDebug'
Export-ModuleMember -Function 'Search-BinDebug' -Alias 'sbd'

function Undo-UnchangedFiles([String] $Path){
    <#
    .SYNOPSIS
    Undo changes to unchanged files.

    .DESCRIPTION
    Undo changes to unchanged files in this folder and all subfolders

    .EXAMPLE
    tfs-uu

    #>

    tfpt uu . /noget /recursive
}
New-Alias -Force -Name 'uu' -Value 'Undo-UnchangedFiles'
Export-ModuleMember -Function 'Undo-UnchangedFiles' -Alias 'uu'



Add-Type @"
  public class solution
{
    public int id;
    public string name;
    public string fullname;
}
"@;

function Open-Solution([String] $Filter){
    <#
    .SYNOPSIS
     Lists and opens sulution found recursively in current folder.

    .DESCRIPTION
     This function lists all solutions found recursively from current folder, then opens the chosen solution. The parameter filter lets you add a filter to solution name.

    .EXAMPLE
    
    Open-Solution
    Open-Solution <et_filter>

    #>
    Write-Host " " 
    Write-Host "Listing all visual studio solutions" -ForegroundColor yellow
    Write-Host " " 

    if($Filter -eq '') {
        $includeCondition = "*.sln"
    }
    else {
        $includeCondition = "*" + $Filter + "*.sln"
    }

    $tempSolutions = ls -r -i $includeCondition | select Name, FullName 

    $si = New-Object solution
    $st = [Type] $si.GetType()
    $base = [System.Collections.Generic.List``1]
    $qt = $base.MakeGenericType(@($st))
    $solutions = [Activator]::CreateInstance($qt)
    for($i = 0; $i -lt $tempSolutions.Count + 1; $i++)
    {
        $obj = New-Object solution
        $obj.id = $i
        $obj.name = $tempSolutions[$i].Name
        $obj.fullname = $tempSolutions[$i].FullName
        $solutions.Add($obj)
    }   
    $solutions | Format-Table -AutoSize
    
    if($solutions.count -eq 0) {
        Write-Host "No visual studio solutions found" -ForegroundColor red
    }
    else{
        if($solutions.count -eq 1) {
            Write-Host -ForegroundColor Yellow "Opening solution:" $solutions[0].name
            ii $solutions[0].fullname
        } else{
            $choice = Read-Host "Enter a number to open a solution (x to exit): " 
            if($choice -eq "x"){
                Write-Host -ForegroundColor red "Exit" -BackgroundColor black
            }
            else
            {
                Write-Host -ForegroundColor Yellow "Opening solution:" $solutions[$choice].name
                ii $solutions[$choice].fullname
            }
        }   
    }
}
New-Alias -Force -Name 'os' -Value 'Open-Solution'
Export-ModuleMember -Function 'Open-Solution' -Alias 'os'

function Build-Solution {
    param
    (
        [parameter(Mandatory = $true)]
        [String] $path,

        [parameter(Mandatory = $false)]
        [bool] $nuget = $true,
        
        [parameter(Mandatory = $false)]
        [bool] $clean = $true
    )
    process {
        $msBuildExe = 'C:\Program Files (x86)\MSBuild\14.0\Bin\msbuild.exe'

        if ($nuget) {
            Write-Host "Restoring NuGet packages" -foregroundcolor green
            nuget restore "$($path)"
        }

        if ($clean) {
            Write-Host "Cleaning $($path)" -foregroundcolor green
            & "$($msBuildExe)" "$($path)" /t:Clean /m
        }

        Write-Host "Building $($path)" -foregroundcolor green
        & "$($msBuildExe)" "$($path)" /t:Build /m
    }
}
New-Alias -Force -Name 'bs' -Value 'Build-Solution'
Export-ModuleMember -Function 'Build-Solution' -Alias 'bs'
