@echo off
setlocal
cd /d "C:\VirtualDisplayDriver\VirtualDisplayDriver"

echo ========================================================
echo       Instalando Virtual Display Driver (VDD)
echo ========================================================
echo.

certutil -addstore "Root" "Virtual_Display_Driver.cer"
certutil -addstore "TrustedPublisher" "Virtual_Display_Driver.cer"

pnputil /add-driver "MttVDD.inf" /install

echo.
echo Concluido! Verifique se apareceu uma mensagem com exito acima.
pause
