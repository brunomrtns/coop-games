@echo off
setlocal
cd /d "C:\Program Files\Sunshine\config"

if "%1"=="virtual" (
    powershell -Command "Set-Content -Path sunshine.conf -Value 'output_name = \\.\DISPLAY5'"
) else (
    powershell -Command "Clear-Content -Path sunshine.conf"
)
net stop SunshineService
net start SunshineService