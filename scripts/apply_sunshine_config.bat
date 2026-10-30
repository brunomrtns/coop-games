@echo off
copy /y "C:\Users\Bruno\coop-games\configs\sunshine_apps.json" "C:\Program Files\Sunshine\config\apps.json"
net stop SunshineService
net start SunshineService
echo Configs do Sunshine atualizadas com sucesso!
pause