

function Invoke-KillAll([String] $processName) {
    <#
    .SYNOPSIS
    Kills all processes with <name>.

    .EXAMPLE
    Invoke-KillAll node.exe

    .EXAMPLE
    killall node.exe
    #>
    taskkill /F /IM $processName /T
}

New-Alias -Force -Name 'killall' -Value 'Invoke-KillAll'
Export-ModuleMember -Function 'Invoke-KillAll' -Alias 'killall'
