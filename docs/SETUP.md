# Guia do Ambiente Coop Remoto (Sunshine + Moonlight + Tailscale + Nucleus Co-op)

Este repositorio documenta e armazena os scripts de automacao e configuracao para jogar qualquer game cooperativo a distancia como se fosse em rede local, com baixissima latencia.

---

## 1. Arquitetura da Solucao

1. **Rede:** [Tailscale](https://tailscale.com/) cria uma rede mesh WireGuard criptografada ponto a ponto (P2P), furando CGNAT sem necessidade de abrir portas no roteador.
2. **Streaming Host:** [Sunshine](https://github.com/LizardByte/Sunshine) roda no PC Host (Windows) como servico nativo, utilizando codificacao de hardware via NVENC (NVIDIA RTX 3060).
3. **Cliente Remoto:** [Moonlight](https://moonlight-stream.org/) roda no dispositivo do Player 2 (PC, Celular Android/iOS, Steam Deck, TV Box).
4. **Controles Virtuais:** [ViGEmBus](https://github.com/nefarius/ViGEmBus) emula os controles do Moonlight como gamepads Xbox 360 nativos no Windows.
5. **Multi-Tela Virtual:** [Virtual Display Driver (VDD)](https://github.com/VirtualDrivers/Virtual-Display-Driver) cria um segundo monitor virtual sob demanda (1080p@60Hz / 120Hz).
6. **Multi-Instancias Coop:** [Nucleus Co-op](https://nucleus-coop.github.io/) roda instâncias isoladas de jogos para cada jogador, posicionando o Player 1 no monitor fisico e o Player 2 no monitor virtual.

---

## 2. Modos de Jogo Disponiveis no Moonlight

No aplicativo do Moonlight do Player 2, aparecem duas opcoes de conexao:

### Modo A: `Desktop / Jogo Padrao (Split-Screen Unico)`
* **Ideal para:** Jogos narrativos ou desenhados para split-screen unificado (*A Way Out*, *It Takes Two*, jogos emulados).
* **Comportamento:** Espelha o monitor principal (`\\.\DISPLAY1`).

### Modo B: `Coop Tela Cheia (Monitor 2 Dedicado)`
* **Ideal para:** Jogos de tiro, corrida, RPG e acao onde cada um deve ver apenas a sua propria camera em tela cheia (*Borderlands*, *Left 4 Dead 2*, *Call of Duty*, *Resident Evil*, etc.).
* **Comportamento:**
  * Liga o Monitor Virtual automaticamente ao iniciar.
  * O Sunshine transmite **apenas a tela virtual** para o Player 2.
  * O Nucleus Co-op joga o Player 1 na tela fisica e o Player 2 na tela virtual.
  * Ao encerrar o streaming, o monitor virtual desliga automaticamente.

---

## 3. Passo a Passo de Reinstalacao em Outro PC

1. **Instalar Tailscale:**
   * Baixar e logar com a conta Tailscale.
   * Compartilhar a maquina com o Player 2 ou adiciona-lo na tailnet.
2. **Instalar Sunshine & ViGEmBus:**
   * Instalar o Sunshine para Windows.
   * O instalador instala o driver de controle `ViGEmBus` automaticamente.
3. **Instalar o Driver de Monitor Virtual (VDD):**
   * Executar como Administrador o script: `scripts/install_driver.bat`.
4. **Instalar Nucleus Co-op:**
   * Extrair ou instalar o instalador em `C:\NucleusCo-op`.
5. **Configurar o Sunshine (`apps.json`):**
   * Adicionar as entradas presentes em `configs/sunshine_apps.json`.
