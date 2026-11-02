Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[System.Windows.Forms.Application]::EnableVisualStyles()
$form = New-Object System.Windows.Forms.Form
$form.Text = "Central Coop - Gerenciador de Streaming e Telas"
$form.Size = New-Object System.Drawing.Size(520, 560)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 24)

# Fontes
$fontTitle = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
$fontSection = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$fontRegular = New-Object System.Drawing.Font("Segoe UI", 9)
$fontBold = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)

# Cores
$colorTextWhite = [System.Drawing.Color]::FromArgb(240, 240, 245)
$colorTextMuted = [System.Drawing.Color]::FromArgb(150, 150, 160)
$colorGreen = [System.Drawing.Color]::FromArgb(46, 204, 113)
$colorRed = [System.Drawing.Color]::FromArgb(231, 76, 60)

# Cabecalho
$lblHeader = New-Object System.Windows.Forms.Label
$lblHeader.Text = "Central de Controle Coop"
$lblHeader.Font = $fontTitle
$lblHeader.ForeColor = $colorTextWhite
$lblHeader.Location = New-Object System.Drawing.Point(20, 15)
$lblHeader.AutoSize = $true
$form.Controls.Add($lblHeader)

$lblSub = New-Object System.Windows.Forms.Label
$lblSub.Text = "Status em tempo real, alternancia de modos e privacidade."
$lblSub.Font = $fontRegular
$lblSub.ForeColor = $colorTextMuted
$lblSub.Location = New-Object System.Drawing.Point(22, 42)
$lblSub.AutoSize = $true
$form.Controls.Add($lblSub)

# --- PAINEL DE STATUS ---
$grpStatus = New-Object System.Windows.Forms.GroupBox
$grpStatus.Text = "  Status dos Componentes  "
$grpStatus.Font = $fontSection
$grpStatus.ForeColor = $colorTextWhite
$grpStatus.Location = New-Object System.Drawing.Point(20, 70)
$grpStatus.Size = New-Object System.Drawing.Size(465, 125)
$form.Controls.Add($grpStatus)

# Indicador 1: Rede / Privacidade
$lblStatusRede = New-Object System.Windows.Forms.Label
$lblStatusRede.Text = "● Rede (Tailscale): Verificando..."
$lblStatusRede.Font = $fontBold
$lblStatusRede.Location = New-Object System.Drawing.Point(15, 28)
$lblStatusRede.AutoSize = $true
$grpStatus.Controls.Add($lblStatusRede)

$lblRedeSub = New-Object System.Windows.Forms.Label
$lblRedeSub.Text = "Carregando..."
$lblRedeSub.Font = $fontRegular
$lblRedeSub.ForeColor = $colorTextMuted
$lblRedeSub.Location = New-Object System.Drawing.Point(32, 48)
$lblRedeSub.AutoSize = $true
$grpStatus.Controls.Add($lblRedeSub)

# Indicador 2: Monitor Virtual
$lblStatusVDD = New-Object System.Windows.Forms.Label
$lblStatusVDD.Text = "● Monitor Virtual: Verificando..."
$lblStatusVDD.Font = $fontBold
$lblStatusVDD.Location = New-Object System.Drawing.Point(15, 75)
$lblStatusVDD.AutoSize = $true
$grpStatus.Controls.Add($lblStatusVDD)

$lblVDDSub = New-Object System.Windows.Forms.Label
$lblVDDSub.Text = "Carregando..."
$lblVDDSub.Font = $fontRegular
$lblVDDSub.ForeColor = $colorTextMuted
$lblVDDSub.Location = New-Object System.Drawing.Point(32, 95)
$lblVDDSub.AutoSize = $true
$grpStatus.Controls.Add($lblVDDSub)

# --- SECAO PRIVACIDADE ---
$btnPrivacidade = New-Object System.Windows.Forms.Button
$btnPrivacidade.Location = New-Object System.Drawing.Point(20, 205)
$btnPrivacidade.Size = New-Object System.Drawing.Size(465, 42)
$btnPrivacidade.Font = $fontBold
$btnPrivacidade.ForeColor = [System.Drawing.Color]::White
$btnPrivacidade.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnPrivacidade.FlatAppearance.BorderSize = 0
$btnPrivacidade.Cursor = [System.Windows.Forms.Cursors]::Hand
$form.Controls.Add($btnPrivacidade)

# --- SECAO MODOS DE JOGO ---
$grpModos = New-Object System.Windows.Forms.GroupBox
$grpModos.Text = "  Selecionar Modo de Jogo e Streaming  "
$grpModos.Font = $fontSection
$grpModos.ForeColor = $colorTextWhite
$grpModos.Location = New-Object System.Drawing.Point(20, 260)
$grpModos.Size = New-Object System.Drawing.Size(465, 190)
$form.Controls.Add($grpModos)

# MODO 1: TELA UNICA (Split-Screen Compartilhado)
$btnModo1 = New-Object System.Windows.Forms.Button
$btnModo1.Text = "1. MODO NORMAL (Monitor Fisico Unico)"
$btnModo1.Location = New-Object System.Drawing.Point(15, 30)
$btnModo1.Size = New-Object System.Drawing.Size(435, 38)
$btnModo1.Font = $fontBold
$btnModo1.ForeColor = [System.Drawing.Color]::White
$btnModo1.BackColor = [System.Drawing.Color]::FromArgb(44, 62, 80)
$btnModo1.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnModo1.Cursor = [System.Windows.Forms.Cursors]::Hand
$grpModos.Controls.Add($btnModo1)

$lblModo1Desc = New-Object System.Windows.Forms.Label
$lblModo1Desc.Text = "Ideal para A Way Out, It Takes Two ou qualquer jogo split-screen local padrao.`nDesativa o monitor virtual para 0% consumo de GPU e transmite sua tela principal."
$lblModo1Desc.Font = $fontRegular
$lblModo1Desc.ForeColor = $colorTextMuted
$lblModo1Desc.Location = New-Object System.Drawing.Point(18, 72)
$lblModo1Desc.Size = New-Object System.Drawing.Size(430, 32)
$grpModos.Controls.Add($lblModo1Desc)

# MODO 2: TELAS SEPARADAS (Nucleus Co-op)
$btnModo2 = New-Object System.Windows.Forms.Button
$btnModo2.Text = "2. MODO 2 TELAS (Ativar Monitor Virtual + Nucleus)"
$btnModo2.Location = New-Object System.Drawing.Point(15, 110)
$btnModo2.Size = New-Object System.Drawing.Size(435, 38)
$btnModo2.Font = $fontBold
$btnModo2.ForeColor = [System.Drawing.Color]::White
$btnModo2.BackColor = [System.Drawing.Color]::FromArgb(142, 68, 173)
$btnModo2.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnModo2.Cursor = [System.Windows.Forms.Cursors]::Hand
$grpModos.Controls.Add($btnModo2)

$lblModo2Desc = New-Object System.Windows.Forms.Label
$lblModo2Desc.Text = "Ativa o monitor virtual e direciona o Sunshine para ele.`nCada jogador joga em tela cheia independente pelo Nucleus Co-op."
$lblModo2Desc.Font = $fontRegular
$lblModo2Desc.ForeColor = $colorTextMuted
$lblModo2Desc.Location = New-Object System.Drawing.Point(18, 152)
$lblModo2Desc.Size = New-Object System.Drawing.Size(430, 30)
$grpModos.Controls.Add($lblModo2Desc)

# --- RODAPE COM BOTOES DE UTILIDADE ---
$btnAbrirNucleus = New-Object System.Windows.Forms.Button
$btnAbrirNucleus.Text = "Abrir Nucleus Co-op"
$btnAbrirNucleus.Location = New-Object System.Drawing.Point(20, 465)
$btnAbrirNucleus.Size = New-Object System.Drawing.Size(225, 34)
$btnAbrirNucleus.Font = $fontRegular
$btnAbrirNucleus.ForeColor = $colorTextWhite
$btnAbrirNucleus.BackColor = [System.Drawing.Color]::FromArgb(52, 73, 94)
$btnAbrirNucleus.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnAbrirNucleus.Cursor = [System.Windows.Forms.Cursors]::Hand
$btnAbrirNucleus.Add_Click({
    $nucleus = "C:\NucleusCo-op\NucleusCoop.exe"
    if (Test-Path $nucleus) { Start-Process $nucleus }
})
$form.Controls.Add($btnAbrirNucleus)

$btnAtualizar = New-Object System.Windows.Forms.Button
$btnAtualizar.Text = "Atualizar Status"
$btnAtualizar.Location = New-Object System.Drawing.Point(260, 465)
$btnAtualizar.Size = New-Object System.Drawing.Size(225, 34)
$btnAtualizar.Font = $fontRegular
$btnAtualizar.ForeColor = $colorTextWhite
$btnAtualizar.BackColor = [System.Drawing.Color]::FromArgb(52, 73, 94)
$btnAtualizar.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnAtualizar.Cursor = [System.Windows.Forms.Cursors]::Hand
$btnAtualizar.Add_Click({ Atualizar-Tudo })
$form.Controls.Add($btnAtualizar)

# --- FUNCAO PRINCIPAL DE ATUALIZACAO ---
function Atualizar-Tudo {
    $tsOnline = $false
    try {
        $tsJson = tailscale status --json 2>$null | ConvertFrom-Json
        if ($tsJson.BackendState -eq "Running") { $tsOnline = $true }
    } catch {
        $tsOnline = $false
    }

    if ($tsOnline) {
        $lblStatusRede.Text = "● Rede (Tailscale): CONECTADA (Amigo Pode Conectar)"
        $lblStatusRede.ForeColor = $colorGreen
        $lblRedeSub.Text = "Streaming liberado. Seus amigos conseguem acessar seus jogos."
        $btnPrivacidade.Text = "MODO PRIVACIDADE: Cortar Conexao (Ficar Invisivel)"
        $btnPrivacidade.BackColor = $colorRed
    } else {
        $lblStatusRede.Text = "● Rede (Tailscale): BLOQUEADA (100% Privado)"
        $lblStatusRede.ForeColor = $colorRed
        $lblRedeSub.Text = "PC blindado. Ninguem consegue ver sua tela ou se conectar."
        $btnPrivacidade.Text = "ATIVAR REDE: Liberar Streaming para Amigo"
        $btnPrivacidade.BackColor = $colorGreen
    }

    # 2. Verificar Monitor Virtual
    $vddDev = Get-PnpDevice | Where-Object { $_.InstanceId -like "*ROOT\DISPLAY\0000*" } -ErrorAction SilentlyContinue
    $vddAtivo = ($vddDev -and $vddDev.Status -eq "OK")

    if ($vddAtivo) {
        $lblStatusVDD.Text = "● Monitor Virtual: ATIVO (Pronto para 2 Telas)"
        $lblStatusVDD.ForeColor = [System.Drawing.Color]::FromArgb(155, 89, 182)
        $lblVDDSub.Text = "O Windows possui a segunda tela ativa para jogos em tela cheia."
        $btnModo2.FlatAppearance.BorderSize = 2
        $btnModo2.FlatAppearance.BorderColor = [System.Drawing.Color]::White
        $btnModo1.FlatAppearance.BorderSize = 0
    } else {
        $lblStatusVDD.Text = "● Monitor Virtual: DESATIVADO (0% Uso de GPU)"
        $lblStatusVDD.ForeColor = $colorGreen
        $lblVDDSub.Text = "Apenas o seu monitor fisico real esta ativo. Sem telas fantasmas."
        $btnModo1.FlatAppearance.BorderSize = 2
        $btnModo1.FlatAppearance.BorderColor = [System.Drawing.Color]::White
        $btnModo2.FlatAppearance.BorderSize = 0
    }
}

# Evento Botao Privacidade
$btnPrivacidade.Add_Click({
    $btnPrivacidade.Enabled = $false
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
    Atualizar-Tudo
    $btnPrivacidade.Enabled = $true
})

# Evento Modo 1 (Desativar Monitor Virtual)
$btnModo1.Add_Click({
    $btnModo1.Enabled = $false
    $controlPath = "C:\Users\Bruno\coop-games\scripts\control_service.ps1"
    Start-Process powershell -Verb RunAs -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$controlPath`" disable" -Wait
    Atualizar-Tudo
    $btnModo1.Enabled = $true
    [System.Windows.Forms.MessageBox]::Show("Modo Normal ativado com sucesso!`n`n- Monitor Virtual: DESATIVADO (0% GPU)`n- Sunshine: Transmitindo Monitor Principal", "Modo Normal")
})

# Evento Modo 2 (Ativar Monitor Virtual)
$btnModo2.Add_Click({
    $btnModo2.Enabled = $false
    $controlPath = "C:\Users\Bruno\coop-games\scripts\control_service.ps1"
    Start-Process powershell -Verb RunAs -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$controlPath`" enable" -Wait
    Atualizar-Tudo
    $btnModo2.Enabled = $true
    [System.Windows.Forms.MessageBox]::Show("Modo 2 Telas ativado com sucesso!`n`n- Monitor Virtual: ATIVO`n- Sunshine: Transmitindo Monitor 2 Virtual`n`nAgora voce pode abrir o Nucleus Co-op e posicionar as janelas!", "Modo 2 Telas")
})

Atualizar-Tudo
$form.ShowDialog()