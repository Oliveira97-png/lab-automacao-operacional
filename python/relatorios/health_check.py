#!/usr/bin/env python3

import socket
import datetime

SERVICOS = [
    {"nome": "Prometheus",    "host": "localhost", "porta": 9090},
    {"nome": "Grafana",       "host": "localhost", "porta": 3000},
    {"nome": "Loki",          "host": "localhost", "porta": 3100},
    {"nome": "Alertmanager",  "host": "localhost", "porta": 9093},
    {"nome": "Node Exporter", "host": "localhost", "porta": 9100},
]

def checar_porta(host, porta, timeout=3):
    try:
        with socket.create_connection((host, porta), timeout):
            return True, "UP"
    except Exception as e:
        return False, str(e)

def gerar_relatorio(resultados):
    data = datetime.datetime.now().strftime('%d/%m/%Y %H:%M')
    print("=" * 40)
    print(f"HEALTH CHECK - {socket.gethostname()}")
    print(f"Gerado em: {data}")
    print("=" * 40)
    for r in resultados:
        status = "UP" if r["status"] else "DOWN"
        print(f"{r['nome']:20} {status:6} {r['host']}:{r['porta']}")
    print("=" * 40)
    ok = sum(1 for r in resultados if r["status"])
    print(f"Resultado: {ok}/{len(resultados)} serviços UP")

resultados = []
for servico in SERVICOS:
    status, mensagem = checar_porta(servico["host"], servico["porta"])
    resultados.append({
        "nome": servico["nome"],
        "host": servico["host"],
        "porta": servico["porta"],
        "status": status,
        "mensagem": mensagem
    })

gerar_relatorio(resultados)
