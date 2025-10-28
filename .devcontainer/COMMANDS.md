# Desenvolvimento com DevContainer

Este arquivo contém comandos úteis para trabalhar com o DevContainer do projeto.

## Comandos Rails

```bash
# Iniciar servidor Rails
rails server -b 0.0.0.0

# Iniciar servidor em background
rails server -b 0.0.0.0 -d

# Console Rails
rails console

# Migrations
rails db:migrate
rails db:rollback
rails db:migrate:status

# Seeds
rails db:seed

# Resetar banco de dados (cuidado!)
rails db:reset
```

## Comandos Sidekiq

```bash
# Iniciar Sidekiq
bundle exec sidekiq

# Iniciar Sidekiq com verbose
bundle exec sidekiq -v

# Iniciar Sidekiq com específica fila
bundle exec sidekiq -q default -q mailers
```

## Comandos de Teste

```bash
# Executar todos os testes
bundle exec rspec

# Executar testes específicos
bundle exec rspec spec/models/
bundle exec rspec spec/controllers/todos_controller_spec.rb
bundle exec rspec spec/models/todo_spec.rb:10

# Executar com formatação
bundle exec rspec --format documentation
```

## Comandos de Assets

```bash
# Compilar assets
rails assets:precompile

# Limpar assets compilados
rails assets:clobber

# Instalar dependências JavaScript
yarn install

# Adicionar nova gem
bundle add nome_da_gem
bundle install
```

## Comandos PostgreSQL

```bash
# Conectar ao PostgreSQL
psql -h postgres -U postgres -d ajax-jquery-crud_development

# Backup do banco
pg_dump -h postgres -U postgres ajax-jquery-crud_development > backup.sql

# Restaurar banco
psql -h postgres -U postgres ajax-jquery-crud_development < backup.sql
```

## Comandos Redis

```bash
# Conectar ao Redis CLI
redis-cli -h redis

# Monitorar comandos Redis
redis-cli -h redis monitor

# Limpar cache Redis
redis-cli -h redis FLUSHALL
```

## Comandos Docker (fora do container)

```bash
# Reconstruir container
docker-compose -f .devcontainer/docker-compose.yml build

# Ver logs
docker-compose -f .devcontainer/docker-compose.yml logs -f app

# Parar todos os serviços
docker-compose -f .devcontainer/docker-compose.yml down

# Parar e remover volumes
docker-compose -f .devcontainer/docker-compose.yml down -v
```

## Tarefas Comuns

### Iniciar ambiente completo

```bash
# Terminal 1: Rails server
rails server -b 0.0.0.0

# Terminal 2: Sidekiq
bundle exec sidekiq

# Terminal 3: Logs
tail -f log/development.log
```

### Criar nova migration

```bash
# Gerar migration
rails generate migration AddColumnToTable column:type

# Editar migration
# Depois executar:
rails db:migrate
```

### Adicionar nova gem

```bash
# Editar Gemfile
# Depois executar:
bundle install

# Se precisar atualizar Gemfile.lock
bundle update nome_da_gem
```

### Debug com Pry

Adicione em qualquer lugar do código:

```ruby
require 'pry'
binding.pry
```

### Troubleshooting

```bash
# Limpar tudo e resetar
rails db:drop db:create db:migrate db:seed
rails tmp:clear
rails assets:clobber

# Reinstalar dependências
bundle install
yarn install

# Verificar status dos serviços
pg_isready -h postgres -U postgres
redis-cli -h redis ping
```

## Extensões VS Code Instaladas

- **Ruby LSP**: IntelliSense para Ruby
- **Rubocop**: Linter e formatador
- **Rails**: Snippets e helpers do Rails
- **SQLTools**: Cliente PostgreSQL integrado
- **Docker**: Gerenciar containers
- **GitLens**: Git avançado
- **ERB Beautify**: Formatador para templates ERB

## Atalhos Úteis

- `Ctrl+Shift+P`: Command Palette
- `Ctrl+` `: Terminal integrado
- `Ctrl+P`: Buscar arquivo
- `Ctrl+Shift+F`: Buscar no workspace
- `F5`: Iniciar debug (se configurado)

## Portas Expostas

- **3000**: Aplicação Rails
- **5432**: PostgreSQL
- **6379**: Redis
- **3001**: Sidekiq Web UI (se configurado)
