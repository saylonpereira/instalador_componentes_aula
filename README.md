# Instalador de Componentes

Instala automaticamente o ambiente de desenvolvimento completo em uma máquina do zero.

## O que é instalado

- **Sublime Text 4** — editor de código
- **Python 3.12** — linguagem de programação
- **PostgreSQL 17** — banco de dados
- **Node.js (LTS)** — ambiente de execução JavaScript
- **Claude Code** — assistente de desenvolvimento com IA

---

## Windows

1. Clique com botão direito em `Instalar.bat`
2. Selecione **"Executar como administrador"**
3. Se o Windows SmartScreen aparecer: clique em **"Mais informações"** → **"Executar assim mesmo"**
4. Se o antivírus bloquear: libere o arquivo e execute novamente

**Requisitos:** Windows 10/11 com winget (App Installer — disponível pela Microsoft Store)

---

## macOS

Abra o Terminal e execute:

```bash
bash instalar-mac.sh
```

Se aparecer aviso de permissão:

```bash
chmod +x instalar-mac.sh && ./instalar-mac.sh
```

**Requisitos:** macOS 12 (Monterey) ou mais recente
