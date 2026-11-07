# Liquid Glass — Fundos (backgrounds)

Vídeos de fundo do launcher Liquid Glass da TV. O app lê `manifest.json` e toca os clips em `clips/`.

## Como renovar os fundos
1. Adicione/troque arquivos `.mp4` em `clips/` (1080p/4K; ideal manter cada um < 50 MB).
2. Edite `manifest.json` listando os clips na ordem desejada (`loop: true` = contínuo).
3. Commit + push. O app pega a lista nova automaticamente (sem reinstalar).
