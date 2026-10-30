Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[System.Windows.Forms.Application]::EnableVisualStyles()
$form = New-Object System.Windows.Forms.Form
$form.Text = "Coop Gaming & Streaming Control Panel"
$form.Size = New-Object System.Drawing.Size(460, 420)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(28, 28, 30)

# Colors & Fonts
$titleFont = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
$subFont = New-Object System.Drawing.Font("Segoe UI", 9)
$boldFont = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)

# Header
$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "Central de Controle Coop"
$lblTitle.Font = $titleFont
$lblTitle.ForeColor = [System.Drawing.Color]::White
$lblTitle.Location = New-Object System.Drawing.Point(20, 15)
$lblTitle.AutoSize = $true
$form.Controls.Add($lblTitle)

$lblDesc = New-Object System.Windows.Forms.Label
$lblDesc.Text = "Controle de privacidade, streaming e modos de jogo."
$lblDesc.Font = $subFont
$lblDesc.ForeColor = [System.Drawing.Color]::Gray
$lblDesc.Location = New-Object System.Drawing.Point(22, 42)
$lblDesc.AutoSize = $true
$form.Controls.Add($lblDesc)

# Status Box
$grpStatus = New-Object System.Windows.Forms.GroupBox
$grpStatus.Text = "Status dos Servicos"
$grpStatus.ForeColor = [System.Drawing.Color]::LightGray
$grpStatus.Location = New-Object System.Drawing.Point(20, 70)
$grpStatus.Size = New-Object System.Drawing.Size(400, 75)
$form.Controls.Add($grpStatus)

$lblTailscale = New-Object System.Windows.Forms.Label
$lblTailscale.Text = "Tailscale: Verificando..."
$lblTailscale.Font = $subFont
$lblTailscale.ForeColor = [System.Drawing.Color]::White
$lblTailscale.Location = New-Object System.Drawing.Point(15, 25)
$lblTailscale.AutoSize = $true
$grpStatus.Controls.Add($lblTailscale)

$lblSunshine = New-Object System.Windows.Forms.Label
$lblSunshine.Text = "Sunshine (Streaming): Ativo"
$lblSunshine.Font = $subFont
$lblSunshine.ForeColor = [System.Drawing.Color]::LightGreen
$lblSunshine.Location = New-Object System.Drawing.Point(15, 48)
$lblSunshine.AutoSize = $true
$grpStatus.Controls.Add($lblSunshine)

# Function to refresh status
function Update-Status {
    $ts = (tailscale status --json | ConvertFrom-Json).BackendState
    if ($ts -eq "Running") {
        $lblTailscale.Text = "Tailscale (Rede): CONECTADO (Visivel para amigos)"
        $lblTailscale.ForeColor = [System.Drawing.Color]::LightGreen
        $btnPriv.Text = "MODO PRIVACIDADE: Desconectar Rede"
        $btnPriv.BackColor = [System.Drawing.Color]::FromArgb(192, 57, 43)
    } else {
        $lblTailscale.Text = "Tailscale (Rede): DESCONECTADO (100% Privado)"
        $lblTailscale.ForeColor = [System.Drawing.Color]::Salmon
        $btnPriv.Text = "ATIVAR REDE: Ficar Visivel para Jogar"
        $btnPriv.BackColor = [System.Drawing.Color]::FromArgb(39, 174, 96)
    }
}

# Privacy Button
$btnPriv = New-Object System.Windows.Forms.Button
$btnPriv.Location = New-Object System.Drawing.Point(20, 160)
$btnPriv.Size = New-Object System.Drawing.Size(400, 42)
$btnPriv.Font = $boldFont
$btnPriv.ForeColor = [System.Drawing.Color]::White
$btnPriv.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnPriv.FlatAppearance.BorderSize = 0
$btnPriv.Cursor = [System.Windows.Forms.Cursors]::Hand
$btnPriv.Add_Click({
    $ts = (tailscale status --json | ConvertFrom-Json).BackendState
    if ($ts -eq "Running") {
        tailscale down
    } else {
        tailscale up
    }
    Update-Status
})
$form.Controls.Add($btnPriv)

# Game Profiles Group
$grpProfiles = New-Object System.Windows.Forms.GroupBox
$grpProfiles.Text = "Acoes Rapidas / Modos de Jogo"
$grpProfiles.ForeColor = [System.Drawing.Color]::LightGray
$grpProfiles.Location = New-Object System.Drawing.Point(20, 215)
$grpProfiles.Size = New-Object System.Drawing.Size(400, 140)
$form.Controls.Add($grpProfiles)

# Button Modo 1
$btnModo1 = New-Object System.Windows.Forms.Button
$btnModo1.Text = "1. Abrir A Way Out (Modo Normal - 1 Tela)"
$btnModo1.Location = New-Object System.Drawing.Point(15, 25)
$btnModo1.Size = New-Object System.Drawing.Size(370, 32)
$btnModo1.Font = $subFont
$btnModo1.ForeColor = [System.Drawing.Color]::White
$btnModo1.BackColor = [System.Drawing.Color]::FromArgb(44, 62, 80)
$btnModo1.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnModo1.Cursor = [System.Windows.Forms.Cursors]::Hand
$btnModo1.Add_Click({
    tailscale up
    Update-Status
    $aWayOut = "C:\Users\Bruno\Downloads\A-Way-Out-SteamRIP.com\A Way Out\Haze1\Binaries\Win64\AWayOut.exe"
    if (Test-Path $aWayOut) {
        Start-Process $aWayOut
    } else {
        [System.Windows.Forms.MessageBox]::Show("Jogo nao encontrado em: $aWayOut")
    }
})
$grpProfiles.Controls.Add($btnModo1)

# Button Modo 2
$btnModo2 = New-Object System.Windows.Forms.Button
$btnModo2.Text = "2. Abrir Nucleus Co-op (Modo 2 Telas Cheias)"
$btnModo2.Location = New-Object System.Drawing.Point(15, 62)
$btnModo2.Size = New-Object System.Drawing.Size(370, 32)
$btnModo2.Font = $subFont
$btnModo2.ForeColor = [System.Drawing.Color]::White
$btnModo2.BackColor = [System.Drawing.Color]::FromArgb(142, 68, 173)
$btnModo2.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnModo2.Cursor = [System.Windows.Forms.Cursors]::Hand
$btnModo2.Add_Click({
    tailscale up
    Update-Status
    $nucleus = "C:\NucleusCo-op\NucleusCoop.exe"
    if (Test-Path $nucleus) {
        Start-Process $nucleus
    } else {
        [System.Windows.Forms.MessageBox]::Show("Nucleus Co-op nao encontrado em: $nucleus")
    }
})
$grpProfiles.Controls.Add($btnModo2)

# Button Open Sunshine Web
$btnWeb = New-Object System.Windows.Forms.Button
$btnWeb.Text = "Abrir Configuracoes Web do Sunshine"
$btnWeb.Location = New-Object System.Drawing.Point(15, 99)
$btnWeb.Size = New-Object System.Drawing.Size(370, 28)
$btnWeb.Font = $subFont
$btnWeb.ForeColor = [System.Drawing.Color]::LightGray
$btnWeb.BackColor = [System.Drawing.Color]::FromArgb(52, 73, 94)
$btnWeb.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnWeb.Cursor = [System.Windows.Forms.Cursors]::Hand
$btnWeb.Add_Click({
    Start-Process "https://localhost:47990"
})
$grpProfiles.Controls.Add($btnWeb)

Update-Status
$form.ShowDialog()