Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[System.Windows.Forms.Application]::EnableVisualStyles()
$form = New-Object System.Windows.Forms.Form
$form.Text = "Central Coop & Privacidade"
$form.Size = New-Object System.Drawing.Size(440, 360)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(24, 24, 27)

$fontTitle = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$fontRegular = New-Object System.Drawing.Font("Segoe UI", 9)
$fontBold = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)

# Header
$lblHeader = New-Object System.Windows.Forms.Label
$lblHeader.Text = "Central Coop"
$lblHeader.Font = $fontTitle
$lblHeader.ForeColor = [System.Drawing.Color]::White
$lblHeader.Location = New-Object System.Drawing.Point(20, 15)
$lblHeader.AutoSize = $true
$form.Controls.Add($lblHeader)

# Status Box
$grpStatus = New-Object System.Windows.Forms.GroupBox
$grpStatus.Text = "Status Real do Sistema"
$grpStatus.ForeColor = [System.Drawing.Color]::LightGray
$grpStatus.Location = New-Object System.Drawing.Point(20, 50)
$grpStatus.Size = New-Object System.Drawing.Size(385, 75)
$form.Controls.Add($grpStatus)

$lblTS = New-Object System.Windows.Forms.Label
$lblTS.Text = "Rede: Verificando..."
$lblTS.Font = $fontRegular
$lblTS.ForeColor = [System.Drawing.Color]::White
$lblTS.Location = New-Object System.Drawing.Point(15, 25)
$lblTS.AutoSize = $true
$grpStatus.Controls.Add($lblTS)

$lblStatusDesc = New-Object System.Windows.Forms.Label
$lblStatusDesc.Text = "..."
$lblStatusDesc.Font = $fontRegular
$lblStatusDesc.ForeColor = [System.Drawing.Color]::LightGray
$lblStatusDesc.Location = New-Object System.Drawing.Point(15, 48)
$lblStatusDesc.AutoSize = $true
$grpStatus.Controls.Add($lblStatusDesc)

function Atualizar-Interface {
    $tsStatus = $null
    try {
        $tsJson = tailscale status --json 2>$null | ConvertFrom-Json
        $tsStatus = $tsJson.BackendState
    } catch {
        $tsStatus = "Stopped"
    }

    if ($tsStatus -eq "Running") {
        $lblTS.Text = "Rede Tailscale: LIGADA (Visivel para Amigos)"
        $lblTS.ForeColor = [System.Drawing.Color]::FromArgb(46, 204, 113)
        $lblStatusDesc.Text = "Streaming liberado. Seus amigos conseguem conectar."
        $lblStatusDesc.ForeColor = [System.Drawing.Color]::LightGreen
        
        $btnToggle.Text = "ATIVAR MODO PRIVACIDADE (Cortar Rede)"
        $btnToggle.BackColor = [System.Drawing.Color]::FromArgb(231, 76, 60)
    } else {
        $lblTS.Text = "Rede Tailscale: DESLIGADA (100% Privado)"
        $lblTS.ForeColor = [System.Drawing.Color]::FromArgb(231, 76, 60)
        $lblStatusDesc.Text = "PC blindado. NINGUEM consegue ver sua tela ou conectar."
        $lblStatusDesc.ForeColor = [System.Drawing.Color]::Salmon

        $btnToggle.Text = "LIGAR REDE (Liberar para Jogar com Amigo)"
        $btnToggle.BackColor = [System.Drawing.Color]::FromArgb(39, 174, 96)
    }
}

# Botao Toggle Privacidade
$btnToggle = New-Object System.Windows.Forms.Button
$btnToggle.Location = New-Object System.Drawing.Point(20, 140)
$btnToggle.Size = New-Object System.Drawing.Size(385, 45)
$btnToggle.Font = $fontBold
$btnToggle.ForeColor = [System.Drawing.Color]::White
$btnToggle.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnToggle.FlatAppearance.BorderSize = 0
$btnToggle.Cursor = [System.Windows.Forms.Cursors]::Hand
$btnToggle.Add_Click({
    $btnToggle.Enabled = $false
    try {
        $tsJson = tailscale status --json 2>$null | ConvertFrom-Json
        if ($tsJson.BackendState -eq "Running") {
            tailscale down
        } else {
            tailscale up
        }
    } catch {
        tailscale down
    }
    Atualizar-Interface
    $btnToggle.Enabled = $true
})
$form.Controls.Add($btnToggle)

# Grupo Acoes
$grpAcoes = New-Object System.Windows.Forms.GroupBox
$grpAcoes.Text = "Acoes Rapidas"
$grpAcoes.ForeColor = [System.Drawing.Color]::LightGray
$grpAcoes.Location = New-Object System.Drawing.Point(20, 200)
$grpAcoes.Size = New-Object System.Drawing.Size(385, 95)
$form.Controls.Add($grpAcoes)

# Botao A Way Out
$btnAWayOut = New-Object System.Windows.Forms.Button
$btnAWayOut.Text = "Iniciar A Way Out (Liga Rede e Abre Jogo)"
$btnAWayOut.Location = New-Object System.Drawing.Point(15, 25)
$btnAWayOut.Size = New-Object System.Drawing.Size(355, 30)
$btnAWayOut.Font = $fontRegular
$btnAWayOut.ForeColor = [System.Drawing.Color]::White
$btnAWayOut.BackColor = [System.Drawing.Color]::FromArgb(41, 128, 185)
$btnAWayOut.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnAWayOut.Cursor = [System.Windows.Forms.Cursors]::Hand
$btnAWayOut.Add_Click({
    tailscale up
    Atualizar-Interface
    $game = "C:\Users\Bruno\Downloads\A-Way-Out-SteamRIP.com\A Way Out\Haze1\Binaries\Win64\AWayOut.exe"
    if (Test-Path $game) { Start-Process $game }
})
$grpAcoes.Controls.Add($btnAWayOut)

# Botao Remover Monitor Virtual Bugado
$btnRemover = New-Object System.Windows.Forms.Button
$btnRemover.Text = "Desinstalar Monitor Virtual do Windows"
$btnRemover.Location = New-Object System.Drawing.Point(15, 60)
$btnRemover.Size = New-Object System.Drawing.Size(355, 25)
$btnRemover.Font = $fontRegular
$btnRemover.ForeColor = [System.Drawing.Color]::LightGray
$btnRemover.BackColor = [System.Drawing.Color]::FromArgb(52, 73, 94)
$btnRemover.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnRemover.Cursor = [System.Windows.Forms.Cursors]::Hand
$btnRemover.Add_Click({
    Start-Process "devmgmt.msc"
    [System.Windows.Forms.MessageBox]::Show("Para remover o monitor virtual:`n1. Na janela que abriu (Gerenciador de Dispositivos), abra 'Adaptadores de video'`n2. Clique com botao direito em 'Virtual Display Driver' e escolha 'Desinstalar dispositivo'.`n`nPronto! Seu PC volta ao estado 100% original sem telas fantasmas.", "Como Remover")
})
$grpAcoes.Controls.Add($btnRemover)

Atualizar-Interface
$form.ShowDialog()