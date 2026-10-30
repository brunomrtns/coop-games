Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[System.Windows.Forms.Application]::EnableVisualStyles()
$form = New-Object System.Windows.Forms.Form
$form.Text = "Central de Controle Coop"
$form.Size = New-Object System.Drawing.Size(460, 430)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(28, 28, 30)

$titleFont = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
$subFont = New-Object System.Drawing.Font("Segoe UI", 9)
$boldFont = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)

$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "Central de Controle Coop"
$lblTitle.Font = $titleFont
$lblTitle.ForeColor = [System.Drawing.Color]::White
$lblTitle.Location = New-Object System.Drawing.Point(20, 15)
$lblTitle.AutoSize = $true
$form.Controls.Add($lblTitle)

$lblDesc = New-Object System.Windows.Forms.Label
$lblDesc.Text = "Controle de privacidade, streaming e telas."
$lblDesc.Font = $subFont
$lblDesc.ForeColor = [System.Drawing.Color]::Gray
$lblDesc.Location = New-Object System.Drawing.Point(22, 42)
$lblDesc.AutoSize = $true
$form.Controls.Add($lblDesc)

$grpStatus = New-Object System.Windows.Forms.GroupBox
$grpStatus.Text = "Status Atual"
$grpStatus.ForeColor = [System.Drawing.Color]::LightGray
$grpStatus.Location = New-Object System.Drawing.Point(20, 70)
$grpStatus.Size = New-Object System.Drawing.Size(400, 75)
$form.Controls.Add($grpStatus)

$lblTailscale = New-Object System.Windows.Forms.Label
$lblTailscale.Text = "Rede: Verificando..."
$lblTailscale.Font = $subFont
$lblTailscale.ForeColor = [System.Drawing.Color]::White
$lblTailscale.Location = New-Object System.Drawing.Point(15, 25)
$lblTailscale.AutoSize = $true
$grpStatus.Controls.Add($lblTailscale)

$lblMonitor = New-Object System.Windows.Forms.Label
$lblMonitor.Text = "Stream Transmitindo: Verificando..."
$lblMonitor.Font = $subFont
$lblMonitor.ForeColor = [System.Drawing.Color]::LightGreen
$lblMonitor.Location = New-Object System.Drawing.Point(15, 48)
$lblMonitor.AutoSize = $true
$grpStatus.Controls.Add($lblMonitor)

function Update-Status {
    $ts = (tailscale status --json | ConvertFrom-Json).BackendState
    if ($ts -eq "Running") {
        $lblTailscale.Text = "Rede Tailscale: ATIVA (Amigo consegue conectar)"
        $lblTailscale.ForeColor = [System.Drawing.Color]::LightGreen
        $btnPriv.Text = "MODO PRIVACIDADE: Bloquear Amigo (Desconectar)"
        $btnPriv.BackColor = [System.Drawing.Color]::FromArgb(192, 57, 43)
    } else {
        $lblTailscale.Text = "Rede Tailscale: BLOQUEADA (100% Invisivel)"
        $lblTailscale.ForeColor = [System.Drawing.Color]::Salmon
        $btnPriv.Text = "ATIVAR REDE: Permitir Conexao do Amigo"
        $btnPriv.BackColor = [System.Drawing.Color]::FromArgb(39, 174, 96)
    }

    $conf = Get-Content "C:\Program Files\Sunshine\config\sunshine.conf" -ErrorAction SilentlyContinue
    if ($conf -match "DISPLAY5") {
        $lblMonitor.Text = "Stream Direcionado para: MONITOR 2 VIRTUAL"
        $lblMonitor.ForeColor = [System.Drawing.Color]::DeepSkyBlue
    } else {
        $lblMonitor.Text = "Stream Direcionado para: MONITOR 1 PRINCIPAL"
        $lblMonitor.ForeColor = [System.Drawing.Color]::LightGreen
    }
}

$btnPriv = New-Object System.Windows.Forms.Button
$btnPriv.Location = New-Object System.Drawing.Point(20, 160)
$btnPriv.Size = New-Object System.Drawing.Size(400, 38)
$btnPriv.Font = $boldFont
$btnPriv.ForeColor = [System.Drawing.Color]::White
$btnPriv.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnPriv.FlatAppearance.BorderSize = 0
$btnPriv.Cursor = [System.Windows.Forms.Cursors]::Hand
$btnPriv.Add_Click({
    $ts = (tailscale status --json | ConvertFrom-Json).BackendState
    if ($ts -eq "Running") { tailscale down } else { tailscale up }
    Update-Status
})
$form.Controls.Add($btnPriv)

$grpProfiles = New-Object System.Windows.Forms.GroupBox
$grpProfiles.Text = "Escolher Tela que o Amigo Enxerga"
$grpProfiles.ForeColor = [System.Drawing.Color]::LightGray
$grpProfiles.Location = New-Object System.Drawing.Point(20, 210)
$grpProfiles.Size = New-Object System.Drawing.Size(400, 155)
$form.Controls.Add($grpProfiles)

$btnSet1 = New-Object System.Windows.Forms.Button
$btnSet1.Text = "Transmitir MONITOR 1 (Modo Normal / A Way Out)"
$btnSet1.Location = New-Object System.Drawing.Point(15, 25)
$btnSet1.Size = New-Object System.Drawing.Size(370, 36)
$btnSet1.Font = $boldFont
$btnSet1.ForeColor = [System.Drawing.Color]::White
$btnSet1.BackColor = [System.Drawing.Color]::FromArgb(44, 62, 80)
$btnSet1.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnSet1.Cursor = [System.Windows.Forms.Cursors]::Hand
$btnSet1.Add_Click({
    Start-Process "C:\Users\Bruno\OneDrive\Área de Trabalho\Ativar_Monitor_1_Principal.bat" -Verb RunAs -Wait
    Update-Status
    [System.Windows.Forms.MessageBox]::Show("Sunshine configurado para transmitir o Monitor 1 (Normal)!", "Sucesso")
})
$grpProfiles.Controls.Add($btnSet1)

$btnSet2 = New-Object System.Windows.Forms.Button
$btnSet2.Text = "Transmitir MONITOR 2 (Modo 2 Telas / Nucleus Coop)"
$btnSet2.Location = New-Object System.Drawing.Point(15, 68)
$btnSet2.Size = New-Object System.Drawing.Size(370, 36)
$btnSet2.Font = $boldFont
$btnSet2.ForeColor = [System.Drawing.Color]::White
$btnSet2.BackColor = [System.Drawing.Color]::FromArgb(142, 68, 173)
$btnSet2.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnSet2.Cursor = [System.Windows.Forms.Cursors]::Hand
$btnSet2.Add_Click({
    Start-Process "C:\Users\Bruno\OneDrive\Área de Trabalho\Ativar_Monitor_2_Virtual.bat" -Verb RunAs -Wait
    Update-Status
    [System.Windows.Forms.MessageBox]::Show("Sunshine configurado para transmitir o Monitor 2 Virtual!", "Sucesso")
})
$grpProfiles.Controls.Add($btnSet2)

$btnNucleus = New-Object System.Windows.Forms.Button
$btnNucleus.Text = "Abrir Nucleus Co-op"
$btnNucleus.Location = New-Object System.Drawing.Point(15, 112)
$btnNucleus.Size = New-Object System.Drawing.Size(370, 30)
$btnNucleus.Font = $subFont
$btnNucleus.ForeColor = [System.Drawing.Color]::LightGray
$btnNucleus.BackColor = [System.Drawing.Color]::FromArgb(52, 73, 94)
$btnNucleus.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnNucleus.Cursor = [System.Windows.Forms.Cursors]::Hand
$btnNucleus.Add_Click({
    Start-Process "C:\NucleusCo-op\NucleusCoop.exe"
})
$grpProfiles.Controls.Add($btnNucleus)

Update-Status
$form.ShowDialog()