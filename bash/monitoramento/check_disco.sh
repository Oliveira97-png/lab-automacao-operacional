#!/bin/bash

LIMITE=${1:-80}
TOKEN="${TELEGRAM_TOKEN:-}"
CHAT_ID="${TELEGRAM_CHAT_ID:-}"
HOST=$(hostname)

enviar_alerta() {
  local MSG="⚠️ DISCO ALTO em $HOST: $1"
  [[ -n "$TOKEN" ]] && curl -s -X POST \
    "https://api.telegram.org/bot${TOKEN}/sendMessage" \
    -d chat_id="$CHAT_ID" \
    -d text="$MSG" > /dev/null
}

df -H | grep -vE '^Filesystem|tmpfs|udev|loop' | awk '{print $5" "$6}' | while read USO MOUNT; do
  PCT=${USO%%%}
  if (( PCT >= LIMITE )); then
    MSG="Partição: $MOUNT | Uso: $USO | Limite: ${LIMITE}%"
    echo "[ALERTA] $MSG"
    enviar_alerta "$MSG"
  else
    echo "[OK] $MOUNT: $USO"
  fi
done
