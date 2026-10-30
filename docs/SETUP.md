# Guia Completo: Ambiente Coop Remoto com Tela Dividida Isolada (Monitor Virtual)

Este repositório documenta a infraestrutura completa para rodar jogos cooperativos à distância como se fossem locais, permitindo tanto o modo split-screen clássico quanto o modo **telas cheias independentes para cada jogador**.

> [!NOTE]
> **Instruções para Agentes de IA / Automações:**
> Este documento foi estruturado para que você (ou outro agente de IA) possa reproduzir e automatizar toda essa instalação em outro PC Windows sem intervenção manual desnecessária.

---

## 1. Arquitetura da Solução

1. **Rede Mesh P2P:** [Tailscale](https://tailscale.com/) cria uma VPN segura WireGuard direta entre as máquinas/celulares, contornando CGNAT sem abrir portas no roteador.
2. **Streaming Host:** [Sunshine](https://github.com/LizardByte/Sunshine) roda no Windows com aceleração de hardware NVENC (RTX 3060).
3. **Cliente Remoto:** [Moonlight](https://moonlight-stream.org/) roda no celular ou PC do Player 2.
4. **Controles Virtuais:** [ViGEmBus](https://github.com/nefarius/ViGEmBus) cria controles Xbox 360 virtuais para o Player 2.
5. **Monitor Virtual:** [Virtual Display Driver (VDD x64)](https://github.com/VirtualDrivers/Virtual-Display-Driver) cria um segundo monitor virtual sob demanda (`\\.\DISPLAY5`).
6. **Multi-Instâncias:** [Nucleus Co-op](https://nucleus-coop.github.io/) roda instâncias isoladas de jogos para cada jogador (Player 1 no monitor físico e Player 2 no monitor virtual).

---

## 2. Como a IA deve Instalar o Nucleus Co-op (Automação Silenciosa)

> [!WARNING]
> **NÃO utilize o `Installer.exe` do Nucleus Co-op.** Ele possui um bug conhecido que tenta baixar arquivos em segundo plano e trava infinitamente numa tela cinza.

### O procedimento correto que deve ser executado via script/CLI:
1. **Baixar o arquivo completo `NucleusApp.zip`** da release oficial no GitHub:
   ```powershell
   $url = "https://github.com/SplitScreen-Me/splitscreenme-nucleus/releases/download/v2.4.2/NucleusApp.zip"
   Invoke-WebRequest -Uri $url -OutFile "$env:TEMP\NucleusApp.zip"
   ```
2. **Atenção à senha do arquivo ZIP:** O pacote do Nucleus Co-op possui senha de descompactação:
   * Senha oficial: `nucleus`
3. **Descompactação via 7-Zip CLI (standalone):**
   * O utilitário nativo `Expand-Archive` do Windows falha por causa do método de compressão e da senha.
   * Utilize o `7za.exe` (ou o binário presente em `scripts/7z/x64/7za.exe` deste repositório) apontando para a raiz `C:\NucleusCo-op`:
   ```powershell
   & "scripts\7z\x64\7za.exe" x "$env:TEMP\NucleusApp.zip" -o"C:\NucleusCo-op" -pnucleus -y
   ```
4. **Criar atalho na Área de Trabalho do usuário:**
   * Crie o atalho apontando para `C:\NucleusCo-op\NucleusCoop.exe` no caminho real do Desktop (atentar se o usuário usa OneDrive: `OneDrive\Área de Trabalho`).

---

## 3. Instalação do Driver de Monitor Virtual (VDD x64)

> [!IMPORTANT]
> O Windows bloqueia a criação automática de nós de exibição virtuais feitos apenas com `pnputil /add-driver`. É necessário passar pelo assistente de hardware nativo do Windows:

1. **Baixar e descompactar os drivers VDD:**
   * Baixe o release `VirtualDisplayDriver-x64.zip` do repositório [VirtualDrivers/Virtual-Display-Driver](https://github.com/VirtualDrivers/Virtual-Display-Driver).
   * Extraia na pasta definitiva: `C:\VirtualDisplayDriver\VirtualDisplayDriver`.
2. **Instalar os Certificados de Teste (Como Admin):**
   ```cmd
   certutil -addstore "Root" "C:\VirtualDisplayDriver\VirtualDisplayDriver\Virtual_Display_Driver.cer"
   certutil -addstore "TrustedPublisher" "C:\VirtualDisplayDriver\VirtualDisplayDriver\Virtual_Display_Driver.cer"
   ```
3. **Instalação do Dispositivo via Assistente:**
   * Execute `hdwwiz` (Assistente de Hardware do Windows).
   * Avançar ➔ "Instalar o hardware que eu selecionar manualmente em uma lista (Avançado)".
   * Selecione **Adaptadores de vídeo** (Display adapters).
   * Clique em **Com disco... (Have Disk)** e aponte para:
     ```text
     C:\VirtualDisplayDriver\VirtualDisplayDriver\MttVDD.inf
     ```
   * Conclua o assistente. O Windows criará o nó de vídeo virtual.

---

## 4. Configuração das Rotas no Sunshine (`apps.json`)

Para que o Sunshine permita ao Moonlight escolher entre o modo normal e o modo tela cheia dedicada:

1. Obtenha os nomes das saídas usando a ferramenta nativa do Sunshine:
   ```cmd
   "C:\Program Files\Sunshine\tools\dxgi-info.exe"
   ```
   * O monitor físico será algo como `\\.\DISPLAY1`.
   * O monitor virtual será algo como `\\.\DISPLAY2` ou `\\.\DISPLAY5`.
2. Configure o arquivo `apps.json` (localizado em `C:\Program Files\Sunshine\config\apps.json`) com base no template em `configs/sunshine_apps.json`:
   * **Desktop (Monitor Principal):** aponta para a tela física.
   * **Coop Tela Cheia (Monitor Virtual):** aponta para a tela virtual (ex: `\\.\DISPLAY5`).
3. Reinicie o serviço do Sunshine:
   ```powershell
   Restart-Service SunshineService
   ```

---

## 5. Como Jogar na Prática

1. **Modo Clássico (Split-Screen Compartilhado):**
   * Usado em jogos como *A Way Out*, *It Takes Two*, etc.
   * O Player 2 conecta no Moonlight e escolhe: **`Desktop (Monitor Principal)`**.
2. **Modo Duas Telas Cheias (Sem Split-Screen):**
   * Usado em jogos compatíveis com o Nucleus Co-op (*Borderlands*, *Left 4 Dead 2*, *Resident Evil*, etc.).
   * O Host abre o **Nucleus Co-op**, escolhe o jogo, posiciona o Player 1 na Tela 1 e o Player 2 na Tela 2.
   * O Player 2 conecta no Moonlight e escolhe: **`Coop Tela Cheia (Monitor 2)`**. Ele receberá **apenas a tela dele em 1080p cheia** no celular ou monitor remoto.
