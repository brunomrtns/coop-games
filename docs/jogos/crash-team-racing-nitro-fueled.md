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

O CTR divide a tela **na vertical** (lado a lado). No Central Coop escolha **"Vertical: Metade Direita (Player 2) - Celular EM PE"**.

Nesse modo o monitor virtual fica **em pé (1080x1920)** e o OBS encaixa a metade do jogo inteira, sem cortar as laterais.

### Celular em pé no Moonlight

O Moonlight oficial do Android **só transmite deitado** (não tem opção de retrato). Para jogar com o celular em pé:

- Use o **Artemis** (fork do Moonlight, `ClassicOldSong/moonlight-android` no GitHub), que funciona com o mesmo Sunshine.
- Nas configurações do Artemis, ative o modo retrato / orientação automática.
- Com o Moonlight oficial deitado, a imagem aparece inteira no centro, com faixas pretas nas laterais.
