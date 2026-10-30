# Guia Completo: Ambiente Coop Remoto com Tela Dividida Isolada (Monitor Virtual)

Este repositório documenta a infraestrutura completa para rodar jogos cooperativos à distância como se fossem locais, permitindo tanto o modo split-screen clássico quanto o modo **telas cheias independentes para cada jogador**.

---

## 1. Arquitetura

1. **Rede Mesh P2P:** [Tailscale](https://tailscale.com/) cria uma VPN segura WireGuard direta entre as máquinas/celulares, contornando CGNAT sem abrir portas.
2. **Streaming Host:** [Sunshine](https://github.com/LizardByte/Sunshine) roda no Windows com aceleração de hardware NVENC (RTX 3060).
3. **Cliente Remoto:** [Moonlight](https://moonlight-stream.org/) roda no celular ou PC do Player 2.
4. **Controles Virtuais:** [ViGEmBus](https://github.com/nefarius/ViGEmBus) cria controles Xbox 360 virtuais para o Player 2.
5. **Monitor Virtual:** [Virtual Display Driver (VDD x64)](https://github.com/VirtualDrivers/Virtual-Display-Driver) cria um segundo monitor virtual sob demanda (`\\.\DISPLAY5`).
6. **Multi-Instâncias:** [Nucleus Co-op](https://nucleus-coop.github.io/) roda instâncias isoladas de jogos para cada jogador (Player 1 no monitor físico e Player 2 no monitor virtual).

---

## 2. Como Reinstalar Tudo do Zero em Qualquer PC

### Passo 1: Drivers e Rede
1. Instale o **Tailscale** e autentique na conta.
2. Instale o **Sunshine** (o instalador já instala o driver de controle ViGEmBus por padrão).

### Passo 2: Instalação Obrigatória do Monitor Virtual (Hardware Legado)
> **IMPORTANTE:** Drivers de vídeo virtuais (.inf) requerem o assistente de hardware do Windows para criar o nó raiz no sistema:
1. Pressione `Windows + R`, digite `hdwwiz` e pressione `Enter`.
2. Clique em **Avançar** ➔ Selecione **"Instalar o hardware que eu selecionar manualmente em uma lista (Avançado)"**.
3. Selecione **Adaptadores de vídeo** (Display adapters) e clique em **Avançar**.
4. Clique no botão **Com disco... (Have Disk)** e aponte para:
   ```text
   C:\VirtualDisplayDriver\VirtualDisplayDriver\MttVDD.inf
   ```
5. Confirme e conclua a instalação. O monitor virtual aparecerá no Gerenciador de Dispositivos e no menu de telas do Windows.

### Passo 3: Nucleus Co-op
1. O Nucleus Co-op não deve ficar no Desktop ou em pastas protegidas.
2. Extraia o pacote oficial em:
   ```text
   C:\NucleusCo-op\NucleusCoop.exe
   ```

### Passo 4: Configurar Perfis no Sunshine (`apps.json`)
O Sunshine expõe duas opções para o Moonlight:
* **"Desktop (Monitor Principal)"**: Transmite a tela física `\\.\DISPLAY1` (ideal para jogos com split-screen unificado como *A Way Out*).
* **"Coop Tela Cheia (Monitor Virtual)"**: Transmite a tela virtual `\\.\DISPLAY5` (ideal para *Borderlands, Left 4 Dead 2, Resident Evil, etc.* via Nucleus Co-op).

Execute o script `scripts/apply_sunshine_config.bat` como Administrador para aplicar as rotas de tela no Sunshine.
