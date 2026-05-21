#!/bin/bash

RETENCAO_DIAS=${1:-30}
LOG_DIR="/var/log"
RELATORIO="/tmp/limpeza_$(date +%Y%m%d).txt"

echo "=== LIMPEZA DE LOGS - $(date) ===" > $RELATORIO
echo "Retenção: $RETENCAO_DIAS dias" >> $RELATORIO
echo "" >> $RELATORIO

ANTES=$(df -h $LOG_DIR | awk 'NR==2{print $3}')
echo "Espaço usado antes: $ANTES" >> $RELATORIO

find $LOG_DIR -name "*.gz" -mtime +$RETENCAO_DIAS -delete

journalctl --vacuum-time=${RETENCAO_DIAS}d >> $RELATORIO 2>&1

DEPOIS=$(df -h $LOG_DIR | awk 'NR==2{print $3}')
echo "Espaço usado depois: $DEPOIS" >> $RELATORIO

cat $RELATORIO
