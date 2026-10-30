# Script para ligar e desligar monitor virtual VDD alterando count no xml
param (
    [ValidateSet("enable", "disable", "toggle", "status")]
    [string]$Action = "toggle"
)

$xmlPath = "C:\VirtualDisplayDriver\VirtualDisplayDriver\vdd_settings.xml"

if (-not (Test-Path $xmlPath)) {
    Write-Error "Arquivo de configuracao VDD nao encontrado em: $xmlPath"
    exit 1
}

[xml]$xml = Get-Content $xmlPath
$currentCount = [int]$xml.vdd_settings.monitors.count

switch ($Action) {
    "enable" {
        $newCount = 1
    }
    "disable" {
        $newCount = 0
    }
    "toggle" {
        if ($currentCount -gt 0) {
            $newCount = 0
        } else {
            $newCount = 1
        }
    }
    "status" {
        if ($currentCount -gt 0) {
            Write-Host "Monitor Virtual: ATIVADO ($currentCount monitor(es))"
        } else {
            Write-Host "Monitor Virtual: DESATIVADO"
        }
        exit 0
    }
}

$xml.vdd_settings.monitors.count = $newCount.ToString()
$xml.Save($xmlPath)

# Avisa o driver para recarregar as configs via Device restart rapido se necessario
$dev = Get-PnpDevice | Where-Object { $_.FriendlyName -like "*Virtual Display*" -or $_.Class -eq "Display" -and $_.Manufacturer -like "*Virtual*" }
if ($dev) {
    Disable-PnpDevice -InstanceId $dev.InstanceId -Confirm:$false -ErrorAction SilentlyContinue
    Start-Sleep -Milliseconds 500
    Enable-PnpDevice -InstanceId $dev.InstanceId -Confirm:$false -ErrorAction SilentlyContinue
}

Write-Host "Status do monitor virtual atualizado para: $newCount"
