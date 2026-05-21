#!/bin/bash

CONTAINERS=("prometheus" "grafana" "loki" "alertmanager")
TOKEN="${TELEGRAM_TOKEN:-}"
CHAT_ID="${TELEGRAM_CHAT_ID:-}"
LOG="/tmp/watch_containers.log"

log() { echo "[$(date '+%d/%m %H:%M')] $1" | tee -a $LOG; }

notify() {
  [[ -n "$TOKEN" ]] && curl -s -X POST \
    "https://api.telegram.org/bot${TOKEN}/sendMessage" \
    -d chat_id="$CHAT_ID" \
    -d text="$1" > /dev/null
}

for CONTAINER in "${CONTAINERS[@]}"; do
  STATUS=$(docker inspect -f '{{.State.Running}}' "$CONTAINER" 2>/dev/null || echo "false")
  if [[ "$STATUS" != "true" ]]; then
    log "ALERTA: $CONTAINER não está rodando. Reiniciando..."
    docker start "$CONTAINER"
    sleep 3
    NEW_STATUS=$(docker inspect -f '{{.State.Running}}' "$CONTAINER")
    if [[ "$NEW_STATUS" == "true" ]]; then
      log "OK: $CONTAINER reiniciado com sucesso"
      notify "✅ Container $CONTAINER reiniciado em $(hostname)"
    else
      log "CRÍTICO: $CONTAINER não subiu após restart!"
      notify "🚨 CRÍTICO: Container $CONTAINER falhou ao reiniciar em $(hostname)"
    fi
  else
    log "OK: $CONTAINER rodando"
  fi
done
