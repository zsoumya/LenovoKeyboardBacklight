Set-StrictMode -Version Latest

if ([System.Environment]::Is64BitProcess) {
    Write-Warning -Message "Launching x86 PowerShell to run $($MyInvocation.MyCommand.Definition)"
    & "$env:windir\syswow64\windowspowershell\v1.0\powershell.exe" -noninteractive -noprofile -file $MyInvocation.MyCommand.Definition
    exit
}

Write-Verbose -Message "Always running in x86 PowerShell at this point"
Write-Verbose -Message "Platform: $(![System.Environment]::Is64BitProcess))"
Write-Verbose -Message "IntPtr Size: $([IntPtr]::Size)"

Add-Type -Path "C:\ProgramData\Lenovo\ImController\Plugins\ThinkKeyboardPlugin\x86\Keyboard_Core.dll"

$kb = [Keyboard_Core.KeyboardControl]::new()

Write-Verbose -Message "Getting max keyboard backlight level"
$level = 0
$kb.GetKeyboardBackLightLevel([ref] $level)

Write-Verbose -Message "Setting keyboard backlight level to max ($level)"
$kb.SetKeyboardBackLightStatus($level)
