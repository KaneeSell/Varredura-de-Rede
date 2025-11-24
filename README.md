

# Varredura de Rede

Ferramenta simples em **Batch Script (.bat)** para realizar varreduras em redes locais, registrar dispositivos online e gerar logs detalhados com estatísticas de ping.
O projeto foi desenvolvido para fins educacionais, permitindo aos alunos compreenderem conceitos de redes, automação e análise básica de conectividade.

**Alunos envolvidos:**
Daniel, Samuel, Ítalo e Fabrício.

---

## 📌 Funcionalidades

* Detecção automática de adaptadores de rede e seus endereços IPv4.
* Seleção do adaptador desejado através de menu.
* Configuração personalizada de:

  * Quantidade de pacotes por ping.
  * Tamanho dos pacotes.
* Geração automática de:

  * `config.ini` — arquivo de configuração usado pela varredura.
  * `scan_ips.txt` — lista completa dos IPs a testar.
* Execução da varredura com:

  * Identificação de IPs online/offline.
  * Coleta de estatísticas detalhadas de ping.
  * Salvamento de logs em `/logs` com data e hora.
* Criação automática da pasta `logs` caso não exista.

---

## 📁 Estrutura dos Arquivos

```
/Varredura-de-Rede
│
├── configurar_rede.bat   # Cria config.ini e gera scan_ips.txt
├── ping_mapper.bat       # Executa a varredura usando as configs
├── config.ini            # Criado automaticamente
├── scan_ips.txt          # Criado automaticamente
└── /logs                 # Logs gerados pela ferramenta
```

---

## ▶️ Como usar

### 1. Configurar a rede

Execute:

```
configurar_rede.bat
```

Esse script:

1. Lista todos os adaptadores disponíveis.
2. Solicita o número do adaptador desejado.
3. Pergunta a quantidade de pacotes e tamanho dos pacotes.
4. Gera:

   * `config.ini` com as configurações escolhidas.
   * `scan_ips.txt` com a lista de IPs a testar (1 a 255).

### 2. Executar a varredura

Após configurado, execute:

```
ping_mapper.bat
```

O script irá:

* Ler o arquivo `scan_ips.txt`.
* Realizar um ping rápido para cada IP.
* Para IPs online, executar um ping mais detalhado.
* Registrar tudo no log dentro da pasta `/logs`.

---

## 📝 Sobre os Logs

Cada execução cria um arquivo no formato:

```
log_YYYY-MM-DD_HH-MM.txt
```

O log contém:

* Estatísticas de pacotes enviados/recebidos/perdidos.
* Tempo mínimo, máximo e médio.
* Separadores entre cada IP analisado.

---

## 🎯 Objetivo Educacional

Este projeto foi criado como exercício prático para:

* Entender rotinas de automação em Windows Batch.
* Manipular arquivos, variáveis e condicionais em `.bat`.
* Desenvolver lógica de varredura sequencial na rede.
* Interpretar resultados básicos de conectividade.
* Trabalhar em equipe e versionamento com Git.
