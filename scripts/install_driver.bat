@echo off
setlocal
cd /d "%~dp0"
echo ========================================================
echo       Instalando Virtual Display Driver (VDD x64)
echo ========================================================
echo.

:: Verifica privilégios de Administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERRO] Este instalador precisa de privilegios de Administrador.
    echo Clique com botao direito e escolha "Executar como Administrador".
    pause
    exit /b 1
)

:: Cria pasta padrao do VDD
if not exist "C:\VirtualDisplayDriver\VirtualDisplayDriver" (
    mkdir "C:\VirtualDisplayDriver\VirtualDisplayDriver"
)

:: Copia arquivos necessarios
xcopy /y /q "%~dp0..\..\..\VirtualDisplayDriver\VirtualDisplayDriver\*.*" "C:\VirtualDisplayDriver\VirtualDisplayDriver\" >nul 2>&1

:: Instala o Certificado nos Roots confiaveis
echo Instalando Certificado do Driver...
certutil -addstore "Root" "C:\VirtualDisplayDriver\VirtualDisplayDriver\Virtual_Display_Driver.cer"
certutil -addstore "TrustedPublisher" "C:\VirtualDisplayDriver\VirtualDisplayDriver\Virtual_Display_Driver.cer"

:: Instala o Driver com pnputil
echo Instalando Driver com pnputil...
pnputil /add-driver "C:\VirtualDisplayDriver\VirtualDisplayDriver\MttVDD.inf" /install

echo.
echo ========================================================
echo    Driver Instalado com Sucesso!
echo ========================================================
pause
