# Lab de Automação Operacional — Bash + Python

Coleção de scripts que automatizam tarefas repetitivas de infraestrutura e monitoramento.
Mentalidade operacional — o que pode ser automatizado, não é feito manualmente.

## Scripts

### Bash — Monitoramento

| Script | Função | Agendamento |
| --- | --- | --- |
| watch_containers.sh | Verifica e reinicia containers parados, notifica no Telegram | A cada 5 minutos |
| check_disco.sh | Monitora uso de disco e alerta quando passa do threshold | A cada 10 minutos |

### Bash — Manutenção

| Script | Função | Agendamento |
| --- | --- | --- |
| limpar_logs.sh | Remove logs antigos e limpa journal do sistema | Todo domingo às 02:00 |

### Python — Alertas

| Script | Função |
| --- | --- |
| alerta_sistema.py | Coleta CPU, memória e disco com psutil e envia alerta no Telegram |

### Python — Relatórios

| Script | Função |
| --- | --- |
| health_check.py | Verifica conectividade de todos os serviços e exibe relatório no terminal |

## Como configurar

Exportar as variáveis de ambiente antes de rodar:

    export TELEGRAM_TOKEN="seu_token"
    export TELEGRAM_CHAT_ID="seu_chat_id"

## Ambiente

- Ubuntu 22.04 LTS
- Python 3.10
- Docker + Docker Compose
- Integração com Telegram Bot API

## Dependências Python

    pip3 install psutil requests
