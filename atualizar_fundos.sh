#!/bin/bash
# Atualiza os fundos (vídeos) do launcher Liquid Glass.
#
# Uso:
#   ./atualizar_fundos.sh                 # usa os .mp4 que já estão em clips/
#   ./atualizar_fundos.sh ~/Downloads/novos_fundos   # copia os .mp4 dessa pasta pra clips/ e sobe
#
# O que faz: (1) copia os vídeos novos pra clips/ (se você passou uma pasta),
# (2) regenera o manifest.json listando TODOS os .mp4 de clips/,
# (3) faz commit e push. O app na TV pega a lista nova sozinho (sem reinstalar).
#
# Dica: mantenha cada vídeo abaixo de ~100 MB. Pra começar num clip específico,
# ajuste "start" no manifest.json (0 = primeiro da lista).

set -e
cd "$(dirname "$0")"

SRC="$1"
if [ -n "$SRC" ]; then
  echo ">> Copiando .mp4 de: $SRC"
  mkdir -p clips
  cp "$SRC"/*.mp4 clips/ 2>/dev/null || { echo "Nenhum .mp4 em $SRC"; exit 1; }
fi

echo ">> Regenerando manifest.json a partir de clips/"
{
  echo '{'
  echo '  "start": 0,'
  echo '  "clips": ['
  first=1
  for f in clips/*.mp4; do
    [ -e "$f" ] || continue
    name=$(basename "$f")
    [ $first -eq 1 ] || echo ','
    first=0
    printf '    {"file": "clips/%s", "loop": true, "label": "%s"}' "$name" "${name%.mp4}"
  done
  echo ''
  echo '  ]'
  echo '}'
} > manifest.json

echo ">> Clips no manifest:"
grep '"file"' manifest.json | sed 's/^/   /'

echo ">> Commit + push"
git add -A
git -c user.email="heitor.guilhermino@shipsmart.global" -c user.name="hguilhermino" \
  commit -qm "Atualiza fundos ($(date +%Y-%m-%d))" || { echo "Nada mudou."; exit 0; }
git push -q origin main
echo ">> Pronto! Os fundos novos vão aparecer na TV em ~1 min (reabra o app se quiser na hora)."
