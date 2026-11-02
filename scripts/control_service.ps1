param([string]$Action)
if ($Action -eq "disable") {
    pnputil /disable-device "ROOT\DISPLAY\0000"
    powershell -Command "Clear-Content -Path 'C:\Program Files\Sunshine\config\sunshine.conf'"
    Restart-Service SunshineService
} elseif ($Action -eq "enable") {
    pnputil /enable-device "ROOT\DISPLAY\0000"
    powershell -Command "Set-Content -Path 'C:\Program Files\Sunshine\config\sunshine.conf' -Value 'output_name = \\.\DISPLAY5'"
    Restart-Service SunshineService
}