# Garantir instancia unica (encerrar janelas antigas do painel que tenham ficado abertas)
$currentPid = $PID
Get-CimInstance Win32_Process -Filter "Name = 'powershell.exe'" -ErrorAction SilentlyContinue | Where-Object {
    $_.ProcessId -ne $currentPid -and $_.CommandLine -like "*painel_coop.ps1*"
} | ForEach-Object {
    Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[System.Windows.Forms.Application]::EnableVisualStyles()
$form = New-Object System.Windows.Forms.Form
$form.Text = "Central Coop - Gerenciador de Streaming e Telas"
$form.Size = New-Object System.Drawing.Size(530, 720)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 24)

# Fontes
$fontTitle = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
$fontSection = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$fontRegular = New-Object System.Drawing.Font("Segoe UI", 9)
$fontBold = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$fontSmall = New-Object System.Drawing.Font("Segoe UI", 8)

# Cores
$colorTextWhite = [System.Drawing.Color]::FromArgb(240, 240, 245)
$colorTextMuted = [System.Drawing.Color]::FromArgb(150, 150, 160)
$colorGreen = [System.Drawing.Color]::FromArgb(46, 204, 113)
$colorRed = [System.Drawing.Color]::FromArgb(231, 76, 60)
$colorPurple = [System.Drawing.Color]::FromArgb(155, 89, 182)
$colorOrange = [System.Drawing.Color]::FromArgb(230, 126, 34)

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
$grpStatus.Location = New-Object System.Drawing.Point(20, 68)
$grpStatus.Size = New-Object System.Drawing.Size(475, 145)
$form.Controls.Add($grpStatus)

# Indicador 1: Rede / Privacidade
$lblStatusRede = New-Object System.Windows.Forms.Label
$lblStatusRede.Text = "● Rede (Tailscale): Verificando..."
$lblStatusRede.Font = $fontBold
$lblStatusRede.Location = New-Object System.Drawing.Point(15, 24)
$lblStatusRede.AutoSize = $true
$grpStatus.Controls.Add($lblStatusRede)

$lblRedeSub = New-Object System.Windows.Forms.Label
$lblRedeSub.Text = "Status da conexao segura P2P"
$lblRedeSub.Font = $fontRegular
$lblRedeSub.ForeColor = $colorTextMuted
$lblRedeSub.Location = New-Object System.Drawing.Point(17, 44)
$lblRedeSub.AutoSize = $true
$grpStatus.Controls.Add($lblRedeSub)

# Indicador 2: Monitor Virtual
$lblStatusVDD = New-Object System.Windows.Forms.Label
$lblStatusVDD.Text = "● Monitor Virtual: Verificando..."
$lblStatusVDD.Font = $fontBold
$lblStatusVDD.Location = New-Object System.Drawing.Point(15, 66)
$lblStatusVDD.AutoSize = $true
$grpStatus.Controls.Add($lblStatusVDD)

$lblVDDSub = New-Object System.Windows.Forms.Label
$lblVDDSub.Text = "Status do driver de tela virtual secundaria"
$lblVDDSub.Font = $fontRegular
$lblVDDSub.ForeColor = $colorTextMuted
$lblVDDSub.Location = New-Object System.Drawing.Point(17, 86)
$lblVDDSub.AutoSize = $true
$grpStatus.Controls.Add($lblVDDSub)

# Indicador 3: Espelho Player 2 (OBS)
$lblStatusMirror = New-Object System.Windows.Forms.Label
$lblStatusMirror.Text = "● Espelho Player 2 (OBS): Verificando..."
$lblStatusMirror.Font = $fontBold
$lblStatusMirror.Location = New-Object System.Drawing.Point(15, 108)
$lblStatusMirror.AutoSize = $true
$grpStatus.Controls.Add($lblStatusMirror)

$lblMirrorSub = New-Object System.Windows.Forms.Label
$lblMirrorSub.Text = "Status da projecao do recorte da tela"
$lblMirrorSub.Font = $fontRegular
$lblMirrorSub.ForeColor = $colorTextMuted
$lblMirrorSub.Location = New-Object System.Drawing.Point(17, 126)
$lblMirrorSub.AutoSize = $true
$grpStatus.Controls.Add($lblMirrorSub)

# --- BOTAO DE PRIVACIDADE ---
$btnPrivacidade = New-Object System.Windows.Forms.Button
$btnPrivacidade.Text = "Alternando Privacidade..."
$btnPrivacidade.Location = New-Object System.Drawing.Point(20, 222)
$btnPrivacidade.Size = New-Object System.Drawing.Size(475, 40)
$btnPrivacidade.Font = $fontBold
$btnPrivacidade.ForeColor = [System.Drawing.Color]::White
$btnPrivacidade.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnPrivacidade.Cursor = [System.Windows.Forms.Cursors]::Hand
$form.Controls.Add($btnPrivacidade)

# --- SECAO MODOS DE JOGO ---
$grpModos = New-Object System.Windows.Forms.GroupBox
$grpModos.Text = "  Selecionar Modo de Jogo e Streaming  "
$grpModos.Font = $fontSection
$grpModos.ForeColor = $colorTextWhite
$grpModos.Location = New-Object System.Drawing.Point(20, 270)
$grpModos.Size = New-Object System.Drawing.Size(475, 345)
$form.Controls.Add($grpModos)

# MODO 1: TELA UNICA
$btnModo1 = New-Object System.Windows.Forms.Button
$btnModo1.Text = "1. MODO NORMAL (Monitor Fisico Unico)"
$btnModo1.Location = New-Object System.Drawing.Point(15, 26)
$btnModo1.Size = New-Object System.Drawing.Size(445, 34)
$btnModo1.Font = $fontBold
$btnModo1.ForeColor = [System.Drawing.Color]::White
$btnModo1.BackColor = [System.Drawing.Color]::FromArgb(44, 62, 80)
$btnModo1.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnModo1.Cursor = [System.Windows.Forms.Cursors]::Hand
$grpModos.Controls.Add($btnModo1)

$lblModo1Desc = New-Object System.Windows.Forms.Label
$lblModo1Desc.Text = "Ideal para A Way Out ou tela unica compartilhada.`nDesativa monitor virtual e espelho (0% consumo extra)."
$lblModo1Desc.Font = $fontRegular
$lblModo1Desc.ForeColor = $colorTextMuted
$lblModo1Desc.Location = New-Object System.Drawing.Point(18, 62)
$lblModo1Desc.Size = New-Object System.Drawing.Size(440, 28)
$grpModos.Controls.Add($lblModo1Desc)

# MODO 2: TELAS SEPARADAS (Nucleus Co-op)
$btnModo2 = New-Object System.Windows.Forms.Button
$btnModo2.Text = "2. MODO 2 TELAS CHEIAS (Nucleus Co-op)"
$btnModo2.Location = New-Object System.Drawing.Point(15, 96)
$btnModo2.Size = New-Object System.Drawing.Size(445, 34)
$btnModo2.Font = $fontBold
$btnModo2.ForeColor = [System.Drawing.Color]::White
$btnModo2.BackColor = [System.Drawing.Color]::FromArgb(142, 68, 173)
$btnModo2.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnModo2.Cursor = [System.Windows.Forms.Cursors]::Hand
$grpModos.Controls.Add($btnModo2)

$lblModo2Desc = New-Object System.Windows.Forms.Label
$lblModo2Desc.Text = "Ativa o monitor virtual e direciona o Sunshine para ele.`nCada jogador fica em tela cheia independente pelo Nucleus."
$lblModo2Desc.Font = $fontRegular
$lblModo2Desc.ForeColor = $colorTextMuted
$lblModo2Desc.Location = New-Object System.Drawing.Point(18, 132)
$lblModo2Desc.Size = New-Object System.Drawing.Size(440, 28)
$grpModos.Controls.Add($lblModo2Desc)

# MODO 3: ESPELHO SPLIT-SCREEN (Jogos Locais de Corrida / Tiro / Coop)
$lblModo3Header = New-Object System.Windows.Forms.Label
$lblModo3Header.Text = "3. MODO ESPELHO SPLIT-SCREEN (Qualquer Jogo Local):"
$lblModo3Header.Font = $fontBold
$lblModo3Header.ForeColor = $colorOrange
$lblModo3Header.Location = New-Object System.Drawing.Point(15, 168)
$lblModo3Header.AutoSize = $true
$grpModos.Controls.Add($lblModo3Header)

$lblDivisao = New-Object System.Windows.Forms.Label
$lblDivisao.Text = "Formato:"
$lblDivisao.Font = $fontRegular
$lblDivisao.ForeColor = $colorTextWhite
$lblDivisao.Location = New-Object System.Drawing.Point(16, 192)
$lblDivisao.AutoSize = $true
$grpModos.Controls.Add($lblDivisao)

$cmbDivisao = New-Object System.Windows.Forms.ComboBox
$cmbDivisao.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$cmbDivisao.BackColor = [System.Drawing.Color]::FromArgb(35, 35, 42)
$cmbDivisao.ForeColor = $colorTextWhite
$cmbDivisao.Font = $fontRegular
$cmbDivisao.Location = New-Object System.Drawing.Point(80, 189)
$cmbDivisao.Size = New-Object System.Drawing.Size(380, 25)
$cmbDivisao.Items.Add("Horizontal: Metade Baixo (Player 2) - Tela Cheia Celular") | Out-Null
$cmbDivisao.Items.Add("Horizontal: Metade Cima (Player 1) - Tela Cheia Celular") | Out-Null
$cmbDivisao.Items.Add("Horizontal: Metade Baixo (Player 2) - Visao Ampla 32:9") | Out-Null
$cmbDivisao.Items.Add("Horizontal: Metade Cima (Player 1) - Visao Ampla 32:9") | Out-Null
$cmbDivisao.Items.Add("Vertical: Metade Direita (Player 2) - Celular EM PE") | Out-Null
$cmbDivisao.Items.Add("Vertical: Metade Esquerda (Player 1) - Celular EM PE") | Out-Null
$cmbDivisao.SelectedIndex = 0
$grpModos.Controls.Add($cmbDivisao)

# Botao Iniciar Espelho
$btnStartMirror = New-Object System.Windows.Forms.Button
$btnStartMirror.Text = "▶ Iniciar Espelho Split"
$btnStartMirror.Location = New-Object System.Drawing.Point(15, 224)
$btnStartMirror.Size = New-Object System.Drawing.Size(270, 36)
$btnStartMirror.Font = $fontBold
$btnStartMirror.ForeColor = [System.Drawing.Color]::White
$btnStartMirror.BackColor = [System.Drawing.Color]::FromArgb(211, 84, 0)
$btnStartMirror.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnStartMirror.Cursor = [System.Windows.Forms.Cursors]::Hand
$grpModos.Controls.Add($btnStartMirror)

# Botao Parar Espelho
$btnStopMirror = New-Object System.Windows.Forms.Button
$btnStopMirror.Text = "⏹ Parar Espelho"
$btnStopMirror.Location = New-Object System.Drawing.Point(295, 224)
$btnStopMirror.Size = New-Object System.Drawing.Size(165, 36)
$btnStopMirror.Font = $fontBold
$btnStopMirror.ForeColor = [System.Drawing.Color]::White
$btnStopMirror.BackColor = [System.Drawing.Color]::FromArgb(120, 40, 31)
$btnStopMirror.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnStopMirror.Cursor = [System.Windows.Forms.Cursors]::Hand
$grpModos.Controls.Add($btnStopMirror)

$lblModo3Desc = New-Object System.Windows.Forms.Label
$lblModo3Desc.Text = "Recorta a metade do jogador e projeta em tela cheia 16:9 no Monitor Virtual.`nZero distorcao. Abra o jogo local que quiser no seu PC e jogue!"
$lblModo3Desc.Font = $fontRegular
$lblModo3Desc.ForeColor = $colorTextMuted
$lblModo3Desc.Location = New-Object System.Drawing.Point(18, 268)
$lblModo3Desc.Size = New-Object System.Drawing.Size(440, 32)
$grpModos.Controls.Add($lblModo3Desc)

# --- RODAPE COM BOTOES DE UTILIDADE ---
$btnAbrirNucleus = New-Object System.Windows.Forms.Button
$btnAbrirNucleus.Text = "Nucleus Co-op"
$btnAbrirNucleus.Location = New-Object System.Drawing.Point(20, 625)
$btnAbrirNucleus.Size = New-Object System.Drawing.Size(145, 36)
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

$btnAjustarTela = New-Object System.Windows.Forms.Button
$btnAjustarTela.Text = "⚙ Ajustar Telas Windows"
$btnAjustarTela.Location = New-Object System.Drawing.Point(175, 625)
$btnAjustarTela.Size = New-Object System.Drawing.Size(165, 36)
$btnAjustarTela.Font = $fontRegular
$btnAjustarTela.ForeColor = $colorTextWhite
$btnAjustarTela.BackColor = [System.Drawing.Color]::FromArgb(52, 73, 94)
$btnAjustarTela.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnAjustarTela.Cursor = [System.Windows.Forms.Cursors]::Hand
$btnAjustarTela.Add_Click({
    Start-Process ms-settings:display
})
$form.Controls.Add($btnAjustarTela)

$btnAtualizar = New-Object System.Windows.Forms.Button
$btnAtualizar.Text = "Atualizar Status"
$btnAtualizar.Location = New-Object System.Drawing.Point(350, 625)
$btnAtualizar.Size = New-Object System.Drawing.Size(145, 36)
$btnAtualizar.Font = $fontRegular
$btnAtualizar.ForeColor = $colorTextWhite
$btnAtualizar.BackColor = [System.Drawing.Color]::FromArgb(52, 73, 94)
$btnAtualizar.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnAtualizar.Cursor = [System.Windows.Forms.Cursors]::Hand
$btnAtualizar.Add_Click({ Atualizar-Tudo })
$form.Controls.Add($btnAtualizar)

# --- FUNCAO PRINCIPAL DE ATUALIZACAO ---
function Atualizar-Tudo {
    # 1. Verificar Tailscale
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
        $lblStatusVDD.Text = "● Monitor Virtual: ATIVO (Pronto para Streaming P2)"
        $lblStatusVDD.ForeColor = $colorPurple
        $lblVDDSub.Text = "A segunda tela esta ligada para jogos em tela cheia."
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

    # 3. Verificar Espelho Player 2 (OBS)
    $obsProc = Get-Process obs64 -ErrorAction SilentlyContinue
    if ($obsProc) {
        $lblStatusMirror.Text = "● Espelho Player 2 (OBS): ATIVO (Transmitindo P2)"
        $lblStatusMirror.ForeColor = $colorOrange
        $lblMirrorSub.Text = "Projetando recorte em tempo real para o celular (Sem gravacao/0% disco)."
        $btnStartMirror.Enabled = $false
        $btnStopMirror.Enabled = $true
    } else {
        $lblStatusMirror.Text = "● Espelho Player 2 (OBS): DESATIVADO (0% GPU)"
        $lblStatusMirror.ForeColor = $colorGreen
        $lblMirrorSub.Text = "Nenhum espelhamento rodando em segundo plano."
        $btnStartMirror.Enabled = $true
        $btnStopMirror.Enabled = $false
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

# Evento Modo 1 (Desativar Monitor Virtual & Espelho)
$btnModo1.Add_Click({
    $btnModo1.Enabled = $false
    # Parar OBS se estiver rodando
    Get-Process obs64 -ErrorAction SilentlyContinue | Stop-Process -Force
    $controlPath = "C:\Users\Bruno\coop-games\scripts\control_service.ps1"
    Start-Process powershell -Verb RunAs -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$controlPath`" disable" -Wait
    Atualizar-Tudo
    $btnModo1.Enabled = $true
    [System.Windows.Forms.MessageBox]::Show("Modo Normal ativado!`n`n- Monitor Virtual: DESATIVADO (0% GPU)`n- Espelho OBS: Encerrado`n- Sunshine: Transmitindo Monitor Principal", "Modo Normal")
})

# Evento Modo 2 (Ativar Monitor Virtual para Nucleus)
$btnModo2.Add_Click({
    $btnModo2.Enabled = $false
    # Parar OBS se estiver rodando para liberar o monitor para o Nucleus
    Get-Process obs64 -ErrorAction SilentlyContinue | Stop-Process -Force
    $controlPath = "C:\Users\Bruno\coop-games\scripts\control_service.ps1"
    Start-Process powershell -Verb RunAs -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$controlPath`" enable" -Wait
    Atualizar-Tudo
    $btnModo2.Enabled = $true
    [System.Windows.Forms.MessageBox]::Show("Modo 2 Telas ativado com sucesso!`n`n- Monitor Virtual: ATIVO`n- Sunshine: Transmitindo Monitor 2 Virtual`n`nAgora voce pode abrir o Nucleus Co-op!", "Modo 2 Telas")
})

# Evento Iniciar Espelho Split
$btnStartMirror.Add_Click({
    $btnStartMirror.Enabled = $false

    # Obter modo selecionado
    $modeParam = "Horizontal_Bottom_Full"
    switch ($cmbDivisao.SelectedIndex) {
        0 { $modeParam = "Horizontal_Bottom_Full" }
        1 { $modeParam = "Horizontal_Top_Full" }
        2 { $modeParam = "Horizontal_Bottom_Wide" }
        3 { $modeParam = "Horizontal_Top_Wide" }
        4 { $modeParam = "Vertical_Right_Full" }
        5 { $modeParam = "Vertical_Left_Full" }
    }

    # Ativar monitor virtual (em pe nos cortes verticais, deitado nos horizontais)
    $orientation = "landscape"; if ($modeParam -like "Vertical_*") { $orientation = "portrait" }
    $controlPath = "C:\Users\Bruno\coop-games\scripts\control_service.ps1"
    Start-Process powershell -Verb RunAs -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$controlPath`" enable $orientation" -Wait

    # Executar script de controle do espelho
    $mirrorScript = "C:\Users\Bruno\coop-games\scripts\control_split_mirror.ps1"
    & $mirrorScript -Action start -Mode $modeParam

    Start-Sleep -Seconds 1
    Atualizar-Tudo
    [System.Windows.Forms.MessageBox]::Show("Modo Espelho Split ativado!`n`n- Formato: $($cmbDivisao.SelectedItem)`n- Monitor Virtual: ATIVO (transmitindo para o celular)`n- OBS: Projetando recorte em tela cheia`n`nAgora abra o jogo desejado no seu PC e conecte o celular via Moonlight!", "Modo Espelho Split")
})

# Evento Parar Espelho
$btnStopMirror.Add_Click({
    $btnStopMirror.Enabled = $false
    $mirrorScript = "C:\Users\Bruno\coop-games\scripts\control_split_mirror.ps1"
    & $mirrorScript -Action stop
    Atualizar-Tudo
    [System.Windows.Forms.MessageBox]::Show("Espelho do Player 2 encerrado com sucesso.`n`nOBS finalizado (0% consumo de GPU).", "Espelho Encerrado")
})

Atualizar-Tudo
$form.ShowDialog()
