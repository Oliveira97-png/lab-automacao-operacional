#!/usr/bin/env python3

import psutil
import requests
import socket
import datetime
import os

TOKEN = os.environ.get("TELEGRAM_TOKEN", "")
CHAT_ID = os.environ.get("TELEGRAM_CHAT_ID", "")

THRESHOLDS = {
    "cpu": 85.0,
    "memoria": 90.0,
    "disco": 92.0,
}

def coletar_metricas():
    return {
        "cpu": psutil.cpu_percent(interval=2),
        "memoria": psutil.virtual_memory().percent,
        "disco": psutil.disk_usage("/").percent,
        "host": socket.gethostname(),
        "hora": datetime.datetime.now().strftime("%d/%m %H:%M"),
    }

def enviar_telegram(msg):
    if not TOKEN:
        print("TOKEN não configurado — pulando notificação")
        return
    requests.post(
        f"https://api.telegram.org/bot{TOKEN}/sendMessage",
        json={"chat_id": CHAT_ID, "text": msg, "parse_mode": "Markdown"}
    )

metricas = coletar_metricas()
alertas = []

for recurso, limite in THRESHOLDS.items():
    valor = metricas[recurso]
    if valor > limite:
        alertas.append(f"• *{recurso.upper()}*: {valor:.1f}% (limite: {limite}%)")

print(f"Host: {metricas['host']} | {metricas['hora']}")
print(f"CPU: {metricas['cpu']}% | Memória: {metricas['memoria']}% | Disco: {metricas['disco']}%")

if alertas:
    msg = f"🚨 *ALERTA - {metricas['host']}*\n🕐 {metricas['hora']}\n" + "\n".join(alertas)
    enviar_telegram(msg)
    print("Alerta enviado no Telegram")
else:
    print("OK: Tudo normal")
