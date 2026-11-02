@echo off
setlocal
if "%1"=="virtual" (
    powershell -ExecutionPolicy Bypass -File "C:\Users\Bruno\coop-games\scripts\control_service.ps1" enable
) else (
    powershell -ExecutionPolicy Bypass -File "C:\Users\Bruno\coop-games\scripts\control_service.ps1" disable
)
