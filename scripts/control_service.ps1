param(
    [string]$Action,
    # landscape = monitor virtual 1920x1080 (cortes horizontais)
    # portrait  = monitor virtual 1080x1920 (cortes verticais, celular em pe)
    [ValidateSet("landscape", "portrait")]
    [string]$Orientation = "landscape"
)

$appsContent = @"
{
  "env": {},
  "apps": [
    {
      "name": "Desktop",
      "image-path": "desktop.png"
    }
  ]
}
"@

$vddXml = @"
<?xml version="1.0" encoding="utf-8"?>
<vdd_settings>
  <monitors>
    <count>1</count>
  </monitors>
  <gpu>
    <friendlyname>default</friendlyname>
  </gpu>
  <resolutions>
    <resolution>
      <width>1920</width>
      <height>1080</height>
      <refresh_rate>60</refresh_rate>
      <refresh_rate>120</refresh_rate>
      <refresh_rate>144</refresh_rate>
      <refresh_rate>165</refresh_rate>
    </resolution>
    <resolution>
      <width>1080</width>
      <height>1920</height>
      <refresh_rate>60</refresh_rate>
    </resolution>
  </resolutions>
  <options>
    <CustomEdid>false</CustomEdid>
    <PreventSpoof>false</PreventSpoof>
    <EdidCeaOverride>false</EdidCeaOverride>
    <HardwareCursor>true</HardwareCursor>
    <SDR10bit>false</SDR10bit>
    <HDRPlus>false</HDRPlus>
  </options>
</vdd_settings>
"@

if ($Action -eq "disable") {
    # Encerrar OBS caso ainda esteja aberto
    Get-Process obs64 -ErrorAction SilentlyContinue | Stop-Process -Force
    pnputil /disable-device "ROOT\DISPLAY\0000"
    if (Test-Path "C:\Program Files\Sunshine\config\sunshine.conf") {
        Clear-Content -Path "C:\Program Files\Sunshine\config\sunshine.conf" -Force
    }
    Set-Content -Path "C:\Program Files\Sunshine\config\apps.json" -Value $appsContent -Force -Encoding UTF8
    Restart-Service SunshineService -ErrorAction SilentlyContinue
} elseif ($Action -eq "enable") {
    # Garantir configuracao do VDD em 1080p com 60/165Hz (sem 800x600@30Hz que trava o DWM do Windows)
    Set-Content -Path "C:\VirtualDisplayDriver\vdd_settings.xml" -Value $vddXml -Force
    Set-Content -Path "C:\VirtualDisplayDriver\VirtualDisplayDriver\vdd_settings.xml" -Value $vddXml -Force

    pnputil /enable-device "ROOT\DISPLAY\0000"
    
    # Aguardar o Windows detectar o novo monitor
    Start-Sleep -Seconds 2
    
    # Forcar resolucao 1920x1080 e taxa de atualizacao alta para sincronizar com o Odyssey G5 (165Hz)
    try {
        Import-Module DisplayConfig -ErrorAction SilentlyContinue
        $v = Get-DisplayInfo -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like "*VDD*" -or $_.DisplayName -like "*Virtual*" }
        if ($v) {
            $id = @($v)[0].DisplayId
            # Sempre volta para paisagem 1920x1080 primeiro (estado conhecido)
            Set-DisplayRotation -DisplayId $id -Rotation None -ErrorAction SilentlyContinue
            Set-DisplayResolution -DisplayId $id -Width 1920 -Height 1080 -ErrorAction SilentlyContinue
            Set-DisplayRefreshRate -DisplayId $id -RefreshRate 60 -ErrorAction SilentlyContinue
            if ($Orientation -eq "portrait") {
                # Monitor virtual em pe (1080x1920) para jogar com o celular na vertical
                try {
                    Set-DisplayRotation -DisplayId $id -Rotation Rotate90 -ErrorAction Stop
                } catch {
                    # Alternativa: modo nativo 1080x1920 do VDD
                    Set-DisplayResolution -DisplayId $id -Width 1080 -Height 1920 -ErrorAction SilentlyContinue
                }
            }
        }
    } catch {}

    # Obter o GUID do monitor virtual no Sunshine
    $vddGuid = "{9acddf6d-43cc-576e-9aff-0c5fc80b4cc8}"
    
    Set-Content -Path "C:\Program Files\Sunshine\config\sunshine.conf" -Value "output_name = $vddGuid" -Force
    Set-Content -Path "C:\Program Files\Sunshine\config\apps.json" -Value $appsContent -Force -Encoding UTF8
    Restart-Service SunshineService -ErrorAction SilentlyContinue
}
