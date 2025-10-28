# 🚀 Guia Rápido - DevContainer

## Pré-requisitos

- [Visual Studio Code](https://code.visualstudio.com/)
- [Docker Desktop](https://www.docker.com/products/docker-desktop) ou Docker Engine + Docker Compose
- Extensão [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) instalada no VS Code

## Como Usar

### 1. Abrir o Projeto no DevContainer

**Opção 1: Via Command Palette**

1. Abra o VS Code no diretório do projeto
2. Pressione `F1` ou `Ctrl+Shift+P` (Linux/Windows) / `Cmd+Shift+P` (Mac)
3. Digite: `Dev Containers: Reopen in Container`
4. Aguarde a construção do container (primeira vez pode levar 5-10 minutos)

**Opção 2: Via Notificação**

1. Abra o VS Code no diretório do projeto
2. Clique em "Reopen in Container" quando a notificação aparecer no canto inferior direito

### 2. Primeira Execução

Após o container ser construído, os scripts de inicialização executarão automaticamente:

- ✅ Instalação de dependências Ruby (`bundle install`)
- ✅ Instalação de dependências JavaScript (`yarn install`)
- ✅ Criação e migração do banco de dados
- ✅ Configuração de extensões VS Code

**Verifique o progresso:**

- Abra o terminal integrado: `` Ctrl+` ``
- Veja os logs na aba "Terminal"

### 3. Iniciando os Serviços

**Opção A: Usando Foreman (Recomendado)**

```bash
foreman start -f Procfile.dev
```

Isso inicia Rails server (porta 3000) e Sidekiq simultaneamente.

**Opção B: Serviços Individuais**

```bash
# Rails Server
rails server -b 0.0.0.0

# Sidekiq (em outro terminal)
bundle exec sidekiq -C config/sidekiq.yml
```

### 4. Acessando a Aplicação

- **Aplicação Web:** <http://localhost:3000>
- **Sidekiq Web UI:** <http://localhost:3000/sidekiq>

## Comandos Úteis

### Banco de Dados

```bash
# Criar banco
rails db:create

# Executar migrações
rails db:migrate

# Resetar banco
rails db:reset

# Seed (popular dados)
rails db:seed

# Console do banco
rails dbconsole
```

### Rails

```bash
# Console Rails
rails console

# Rotas
rails routes

# Executar testes
rspec
# ou
bundle exec rspec spec/models/todo_spec.rb
```

### Docker & Container

```bash
# Ver logs dos serviços
docker-compose -f .devcontainer/docker-compose.yml logs

# Reiniciar um serviço específico
docker-compose -f .devcontainer/docker-compose.yml restart redis

# Parar todos os serviços
docker-compose -f .devcontainer/docker-compose.yml down
```

### Redis & Sidekiq

```bash
# Acessar Redis CLI
redis-cli -h redis

# Limpar filas Sidekiq
bundle exec sidekiq -q default -c 1
```

## Estrutura dos Serviços

O DevContainer cria os seguintes serviços:

| Serviço | Host | Porta | Descrição |
|---------|------|-------|-----------|
| rails | localhost | 3000 | Aplicação Rails |
| db | db | 5432 | PostgreSQL 12 |
| redis | redis | 6379 | Redis Server |

## Troubleshooting

### Container não inicia

```bash
# Reconstruir container do zero
# No VS Code: F1 > "Dev Containers: Rebuild Container"

# Ou via linha de comando:
docker-compose -f .devcontainer/docker-compose.yml down -v
docker-compose -f .devcontainer/docker-compose.yml build --no-cache
```

### Banco de dados com problemas

```bash
# Resetar completamente o banco
rails db:drop db:create db:migrate

# Verificar conexão PostgreSQL
psql -h db -U postgres -d todo_ajax_datatable_development
```

### Permissões de arquivos

```bash
# Dar permissões aos scripts
chmod +x .devcontainer/*.sh

# Recriar vendor/bundle
rm -rf vendor/bundle
bundle install
```

### Sidekiq não processa jobs

```bash
# Verificar se Redis está rodando
redis-cli -h redis ping

# Reiniciar Sidekiq
pkill -f sidekiq
bundle exec sidekiq -C config/sidekiq.yml
```

### Portas em uso

```bash
# Verificar processos usando as portas
lsof -i :3000
lsof -i :5432
lsof -i :6379

# Parar processos se necessário
# Ou altere as portas no docker-compose.yml
```

## Extensões VS Code Incluídas

O DevContainer instala automaticamente:

- ✨ **Ruby** - Suporte à linguagem Ruby
- 🔍 **Ruby Solargraph** - IntelliSense e autocomplete
- 🧪 **Rails** - Suporte ao framework Rails
- 🗃️ **PostgreSQL** - Cliente PostgreSQL
- 🐋 **Docker** - Gerenciamento de containers
- 📝 **ERB Formatter** - Formatação de templates ERB
- 🎨 **EditorConfig** - Consistência de estilo

## Dicas de Produtividade

### Atalhos Úteis no VS Code

- `Ctrl+`` ` - Toggle terminal
- `Ctrl+Shift+P` - Command palette
- `Ctrl+P` - Quick open file
- `F12` - Go to definition
- `Shift+F12` - Find all references

### Debugging

O DevContainer está configurado para debugging:

1. Adicione breakpoint no código (clique à esquerda do número da linha)
2. Pressione `F5` para iniciar o debugger
3. Use `F10` (step over), `F11` (step into), `Shift+F11` (step out)

### Git no Container

O Git está configurado e suas credenciais locais são compartilhadas:

```bash
git status
git add .
git commit -m "mensagem"
git push
```

## Customizações

### Adicionar Gems

1. Edite o `Gemfile`
2. Execute: `bundle install`
3. Reinicie o servidor

### Adicionar Pacotes JavaScript

1. Execute: `yarn add nome-do-pacote`
2. Reinicie o servidor se necessário

### Modificar Configuração do Container

1. Edite `.devcontainer/devcontainer.json` ou `docker-compose.yml`
2. Reconstrua o container: `F1 > Dev Containers: Rebuild Container`

## Manutenção

### Limpar Volumes Docker

```bash
# Cuidado: isso remove TODOS os dados do banco!
docker-compose -f .devcontainer/docker-compose.yml down -v
```

### Atualizar Dependências

```bash
# Ruby
bundle update

# JavaScript
yarn upgrade

# Gems de segurança
bundle update --conservative

# Verificar gems desatualizadas
bundle outdated
```

## Saindo do DevContainer

1. `F1` > `Dev Containers: Reopen Folder Locally`
2. Ou simplesmente feche o VS Code

Os containers continuarão rodando em background. Para pará-los:

```bash
docker-compose -f .devcontainer/docker-compose.yml down
```

---

📚 **Documentação Completa:** Veja [README.md](.devcontainer/README.md) e [COMMANDS.md](.devcontainer/COMMANDS.md)

🐛 **Problemas?** Abra uma issue no repositório ou consulte a documentação oficial do [Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)
