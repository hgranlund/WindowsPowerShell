function snake() {
    <#
    .SYNOPSIS
    Play snake :-)
    #>
	$script = "{0}\Snake.ps1" -f $PSScriptRoot
    &($script)
}