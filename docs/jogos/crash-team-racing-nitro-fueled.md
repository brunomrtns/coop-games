# Crash Team Racing Nitro-Fueled (port PC / SacredFire) — 2 jogadores

Notas específicas deste jogo. Nada aqui altera os scripts do `coop-games` (que continuam genéricos); tudo é configurado **dentro da pasta do jogo**.

## 1. Atribuir os 2 controles

O jogo detecta os dois controles, mas na tela de 2 jogadores pede "conecte o controle" até que cada um seja atribuído a uma porta:

1. Abra o jogo e pressione **`Insert`** (ou **L3 + R3**) para abrir o menu do port.
2. Vá em **Controllers (split screen)**.
3. Coloque o **Controle 1 → Port 1** e o **Controle 2 → Port 2**.
4. Feche o menu. O jogo loga o `user 2` e libera o modo 2 jogadores.

A atribuição fica salva em `bbport.ini` (`port.1=` / `port.2=`).

## 2. Crash ao entrar na seleção de personagem 2P

**Sintoma:** o jogo fecha ao entrar na seleção de personagem de 2 jogadores (às vezes também na abertura). O `last_run.log` termina com:

```
NOTICE: [Net]:  : Loading hero DriverCrash [...] forPlayID:1
--- the game ended with code 3221225477
```

`3221225477` = `0xC0000005` (violação de acesso).

**Causa (análise dos minidumps em `%LOCALAPPDATA%\CrashDumps\sacredfire.exe.*.dmp`):** todos os crashes acontecem em `libwinpthread-1.dll + 0x4263` (`pthread_mutex_trylock`), chamado pelo `mutex_lock` do `sacredfire.exe`, com a estrutura interna do mutex corrompida. É um bug do emulador/port, não do Moonlight/OBS/controles.

**Correção (confirmada):** em `bbport.ini`, desativar a compilação assíncrona de pipelines:

```ini
async_pipelines=0
```

- Faça backup antes: `bbport.ini` → `bbport.ini.bak`.
- Efeito colateral possível: pequenos engasgos na primeira vez que uma pista/efeito é carregado (shaders compilados na hora).
- Para reverter: restaurar o `bbport.ini.bak` ou voltar para `async_pipelines=1`.

## 3. Uso com o split-screen do coop-games

Com o jogo em tela cheia no monitor principal (1920x1080), use no Central Coop o corte **horizontal** (cima/baixo), que é o que o CTR usa no modo 2 jogadores.
