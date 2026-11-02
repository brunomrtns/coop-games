param(
    [ValidateSet(
        "Horizontal_Bottom_Full",
        "Horizontal_Top_Full",
        "Horizontal_Bottom_Wide",
        "Horizontal_Top_Wide",
        "Vertical_Right_Full",
        "Vertical_Left_Full"
    )]
    [string]$Mode = "Horizontal_Bottom_Full"
)

$obsDir = "C:\Users\Bruno\coop-games\tools\obs-studio"
$sceneDir = "$obsDir\config\obs-studio\basic\scenes"
New-Item -ItemType Directory -Path $sceneDir -Force | Out-Null

# O monitor principal real Odyssey G5 e 2560x1440 (16:9)
# Para telas de celular (16:9 / 20:9) sem barras pretas e sem espremer personagens,
# o corte focado centraliza a metade do jogador em proporcao exata 16:9 (1280x720 -> 1920x1080):
$cropTop = 0
$cropBottom = 0
$cropLeft = 0
$cropRight = 0
$boundsType = 2 # Fit / Scale to inner

switch ($Mode) {
    "Horizontal_Bottom_Full" {
        # Metade de baixo (Player 2) - Recorte 16:9 centralizado (1280x720) que preenche 100% da tela do celular
        $cropTop = 720
        $cropBottom = 0
        $cropLeft = 640
        $cropRight = 640
        $boundsType = 2
    }
    "Horizontal_Top_Full" {
        # Metade de cima (Player 1) - Recorte 16:9 centralizado (1280x720)
        $cropTop = 0
        $cropBottom = 720
        $cropLeft = 640
        $cropRight = 640
        $boundsType = 2
    }
    "Horizontal_Bottom_Wide" {
        # Metade de baixo inteira (2560x720) - Visao periferica ampla com barras suaves
        $cropTop = 720
        $cropBottom = 0
        $cropLeft = 0
        $cropRight = 0
        $boundsType = 2
    }
    "Horizontal_Top_Wide" {
        # Metade de cima inteira (2560x720) - Visao periferica ampla com barras suaves
        $cropTop = 0
        $cropBottom = 720
        $cropLeft = 0
        $cropRight = 0
        $boundsType = 2
    }
    "Vertical_Right_Full" {
        # Metade da direita (Player 2) - Recorte 16:9 centralizado (1280x720)
        $cropTop = 360
        $cropBottom = 360
        $cropLeft = 1280
        $cropRight = 0
        $boundsType = 2
    }
    "Vertical_Left_Full" {
        # Metade da esquerda (Player 1) - Recorte 16:9 centralizado (1280x720)
        $cropTop = 360
        $cropBottom = 360
        $cropLeft = 0
        $cropRight = 1280
        $boundsType = 2
    }
}

# Identificador exato verificado do monitor principal Samsung Odyssey G5
$exactId = "\\?\DISPLAY#SAM7486#5&2db14902&0&UID20741#{e6f07b5f-ee97-4a90-b076-33f57bf4eaa7}"

$luaScriptPath = "C:/Users/Bruno/coop-games/scripts/auto_projector.lua"

$sceneCollection = [ordered]@{
    "current_scene" = "CoopSplitScene"
    "current_program_scene" = "CoopSplitScene"
    "name" = "CoopSplit"
    "scene_order" = @(
        [ordered]@{ "name" = "CoopSplitScene" }
    )
    "modules" = [ordered]@{
        "scripts-tool" = @(
            [ordered]@{ "path" = $luaScriptPath }
        )
    }
    "sources" = @(
        [ordered]@{
            "id" = "scene"
            "name" = "CoopSplitScene"
            "versioned_id" = "scene"
            "settings" = [ordered]@{
                "id_counter" = 3
                "custom_size" = $false
                "items" = @(
                    [ordered]@{
                        "name" = "Screen_Capture"
                        "source_uuid" = "c7484df6-1234-5678-90ab-cdef12345678"
                        "visible" = $true
                        "locked" = $true
                        "pos" = [ordered]@{ "x" = 0.0; "y" = 0.0 }
                        "crop_top" = $cropTop
                        "crop_bottom" = $cropBottom
                        "crop_left" = $cropLeft
                        "crop_right" = $cropRight
                        "bounds_type" = $boundsType
                        "bounds_align" = 0
                        "bounds" = [ordered]@{ "x" = 1920.0; "y" = 1080.0 }
                    }
                )
            }
        },
        [ordered]@{
            "id" = "monitor_capture"
            "name" = "Screen_Capture"
            "uuid" = "c7484df6-1234-5678-90ab-cdef12345678"
            "versioned_id" = "monitor_capture"
            "settings" = [ordered]@{
                "monitor_id" = $exactId
                "capture_cursor" = $false
                "method" = 0
            }
        }
    )
}

$json = $sceneCollection | ConvertTo-Json -Depth 10
Set-Content -Path "$sceneDir\CoopSplit.json" -Value $json -Force -Encoding UTF8

# Sincronizar tambem com o AppData por garantia
$appdataScenes = "$env:APPDATA\obs-studio\basic\scenes"
if (-not (Test-Path $appdataScenes)) { New-Item -ItemType Directory -Path $appdataScenes -Force | Out-Null }
Set-Content -Path "$appdataScenes\CoopSplit.json" -Value $json -Force -Encoding UTF8

# Garantir perfil CoopSplit no AppData
$appdataProfile = "$env:APPDATA\obs-studio\basic\profiles\CoopSplit"
if (-not (Test-Path $appdataProfile)) { New-Item -ItemType Directory -Path $appdataProfile -Force | Out-Null }
Copy-Item -Path "$obsDir\config\obs-studio\basic\profiles\CoopSplit\*" -Destination $appdataProfile -Force -ErrorAction SilentlyContinue

# Desativar dialogos de primeira execucao no AppData global.ini
$appdataGlobal = "$env:APPDATA\obs-studio\global.ini"
if (Test-Path $appdataGlobal) {
    $content = Get-Content $appdataGlobal -Raw
    if ($content -notmatch "FirstRun=false") {
        $content = $content -replace "\[General\]", "[General]`r`nFirstRun=false"
        Set-Content -Path $appdataGlobal -Value $content -Force
    }
}

# Limpar arquivos de crash (.sentinel) para nunca exibir tela de Safe Mode
Remove-Item -Path "$env:APPDATA\obs-studio\.sentinel" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$obsDir\config\obs-studio\.sentinel" -Recurse -Force -ErrorAction SilentlyContinue

Write-Output "Configured CoopSplit scene with mode: $Mode (bounds_type: $boundsType)"
