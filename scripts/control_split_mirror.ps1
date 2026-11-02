param(
    [ValidateSet("start", "stop", "status")]
    [string]$Action = "status",
    [string]$Mode = "Horizontal_Bottom_Full"
)

$obsExe = "C:\Users\Bruno\coop-games\tools\obs-studio\bin\64bit\obs64.exe"
$obsDir = "C:\Users\Bruno\coop-games\tools\obs-studio\bin\64bit"
$scriptsDir = "C:\Users\Bruno\coop-games\scripts"

if ($Action -eq "status") {
    $proc = Get-Process obs64 -ErrorAction SilentlyContinue
    if ($proc) {
        Write-Output "RUNNING"
    } else {
        Write-Output "STOPPED"
    }
} elseif ($Action -eq "start") {
    # 1. Configurar o modo de corte da cena
    & "$scriptsDir\config_split_mirror.ps1" -Mode $Mode

    # 2. Finalizar instancias anteriores do OBS e limpar sentinels
    Get-Process obs64 -ErrorAction SilentlyContinue | Stop-Process -Force
    cmd /c "rmdir /s /q `"$env:APPDATA\obs-studio\.sentinel`" 2>nul & rmdir /s /q `"$obsDir\..\..\config\obs-studio\.sentinel`" 2>nul"

    # 3. Iniciar o OBS minimizado com o perfil CoopSplit
    $obsArgs = "--portable --profile CoopSplit --collection CoopSplit"
    Start-Process -FilePath $obsExe -WorkingDirectory $obsDir -ArgumentList $obsArgs -WindowStyle Minimized
    Start-Sleep -Seconds 2

    Write-Output "STARTED"
} elseif ($Action -eq "stop") {
    # Finalizar OBS e limpar sentinels
    Get-Process obs64 -ErrorAction SilentlyContinue | Stop-Process -Force
    cmd /c "rmdir /s /q `"$env:APPDATA\obs-studio\.sentinel`" 2>nul & rmdir /s /q `"$obsDir\..\..\config\obs-studio\.sentinel`" 2>nul"
    Write-Output "STOPPED"
}
