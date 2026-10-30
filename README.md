# Coop Games Remote Setup 🎮

Ambiente completo de cooperação remota de alta performance via **Tailscale**, **Sunshine**, **Moonlight** e **Nucleus Co-op**.

Permite que dois jogadores joguem games de PC e emuladores à distância, cada um com sua própria tela cheia (sem split-screen), ou no modo clássico compartilhado.

## Estrutura do Repositório

* `docs/`: Manuais e arquitetura do ambiente (`SETUP.md`).
* `scripts/`:
  * `install_driver.bat`: Script automatizado para registrar certificados e instalar o driver de display virtual x64.
  * `toggle_virtual_monitor.ps1`: Script que liga e desliga o monitor virtual sob demanda no Windows.
* `configs/`:
  * `sunshine_apps.json`: Configuração dos aplicativos e perfis de exibição do Sunshine.

## Como Usar

Consulte o guia completo em [docs/SETUP.md](docs/SETUP.md).
