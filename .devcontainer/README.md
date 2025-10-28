# DevContainer - TODO AJAX DataTable

## 📋 Visão Geral

Esta configuração de DevContainer fornece um ambiente de desenvolvimento completo e consistente para o projeto TODO AJAX DataTable, com todas as dependências e serviços necessários.

## 🚀 Início Rápido

### Pré-requisitos

- Visual Studio Code instalado
- Extensão "Dev Containers" (ms-vscode-remote.remote-containers) instalada
- Docker e Docker Compose instalados e rodando

### Como Usar

1. **Abrir no DevContainer:**
   - Abra o VS Code no diretório do projeto
   - Pressione `F1` ou `Ctrl+Shift+P` (Linux/Windows) / `Cmd+Shift+P` (Mac)
   - Digite: `Dev Containers: Reopen in Container`
   - Aguarde a construção do container (primeira vez pode demorar 5-10 minutos)

2. **Iniciar a aplicação:**

   ```bash
   # Terminal 1 - Rails Server
   rails server -b 0.0.0.0

   # Terminal 2 - Sidekiq (para jobs assíncronos)
   bundle exec sidekiq
   ```

3. **Acessar a aplicação:**
   - Aplicação: <http://localhost:3000>
   - Sidekiq Web UI: <http://localhost:3000/sidekiq>

## 🏗️ Arquitetura

### Serviços Incluídos

- **app**: Container principal com Ruby 2.5.3, Rails 5.2.3, Node.js 14
- **postgres**: PostgreSQL 12 com extensões pg_trgm e unaccent
- **redis**: Redis 7 para Sidekiq e cache

### Volumes

- `todo-ajax-datatable-gems`: Gems do Ruby (persistente)
- `todo-ajax-datatable-node-modules`: Módulos Node.js (persistente)
- `postgres-data`: Dados do PostgreSQL (persistente)
- `redis-data`: Dados do Redis (persistente)

### Portas Expostas

| Porta | Serviço | Descrição |
|-------|---------|-----------|
| 3000 | Rails | Aplicação principal |
| 3001 | Sidekiq Web | Interface web do Sidekiq (opcional) |
| 5432 | PostgreSQL | Banco de dados |
| 6379 | Redis | Cache e filas |

## 🛠️ Extensões VS Code Incluídas

### Ruby/Rails

- **Shopify.ruby-lsp**: Language Server Protocol para Ruby
- **misogi.ruby-rubocop**: Linter Rubocop
- **bung87.rails**: Snippets e helpers Rails
- **hridoy.rails-snippets**: Mais snippets Rails

### Database

- **mtxr.sqltools**: Interface SQL
- **mtxr.sqltools-driver-pg**: Driver PostgreSQL

### JavaScript/Frontend

- **dbaeumer.vscode-eslint**: Linter ESLint
- **esbenp.prettier-vscode**: Formatador de código

### Utilidades

- **eamodio.gitlens**: Integração Git avançada
- **wayou.vscode-todo-highlight**: Destacar TODOs
- **streetsidesoftware.code-spell-checker**: Corretor ortográfico

## 📝 Comandos Úteis

### Rails

```bash
# Iniciar servidor
rails server -b 0.0.0.0

# Console interativo
rails console

# Executar migrations
rails db:migrate

# Reverter última migration
rails db:rollback

# Seed do banco
rails db:seed

# Ver rotas
rails routes

# Gerar novos recursos
rails generate model Nome
rails generate controller Nome
```

### Sidekiq

```bash
# Iniciar Sidekiq
bundle exec sidekiq

# Iniciar com verbosidade
bundle exec sidekiq -v

# Ver filas
bundle exec sidekiq -q default -q mailers
```

### Database

```bash
# Criar bancos
rails db:create

# Resetar banco (cuidado!)
rails db:reset

# Conectar ao PostgreSQL
psql -h postgres -U postgres -d ajax-jquery-crud_development
```

### Testes

```bash
# Executar todos os testes
bundle exec rspec

# Executar testes específicos
bundle exec rspec spec/models/
bundle exec rspec spec/controllers/todos_controller_spec.rb

# Com formato de documentação
bundle exec rspec --format documentation

# Com coverage
COVERAGE=true bundle exec rspec
```

### Assets

```bash
# Pré-compilar assets
rails assets:precompile

# Limpar assets compilados
rails assets:clobber
```

### Bundle

```bash
# Instalar gems
bundle install

# Atualizar gems
bundle update

# Verificar gems desatualizadas
bundle outdated
```

## 🔧 Configurações

### Banco de Dados

As conexões SQL estão pré-configuradas no VS Code:

- **PostgreSQL - Development**: Banco de desenvolvimento
- **PostgreSQL - Test**: Banco de testes

Para conectar, use a extensão SQLTools (ícone de banco de dados na barra lateral).

### Variáveis de Ambiente

As variáveis de ambiente estão definidas em:

- `devcontainer.json` (remoteEnv)
- `docker-compose.yml` (environment)

Para adicionar novas variáveis, edite esses arquivos ou crie um arquivo `.env`.

### Database.yml

O arquivo `config/database.yml` usa variáveis de ambiente que já estão configuradas:

```yaml
development:
  adapter: postgresql
  host: <%= ENV['DATABASE_HOST'] || 'postgres' %>
  username: <%= ENV['DATABASE_USERNAME'] || 'postgres' %>
  password: <%= ENV['DATABASE_PASSWORD'] || 'admin' %>
```

## 🐛 Troubleshooting

### Container não inicia

```bash
# Reconstruir container
F1 > Dev Containers: Rebuild Container

# Ver logs do Docker
docker-compose -f .devcontainer/docker-compose.yml logs
```

### PostgreSQL não conecta

```bash
# Verificar se está rodando
docker-compose -f .devcontainer/docker-compose.yml ps

# Ver logs do PostgreSQL
docker-compose -f .devcontainer/docker-compose.yml logs postgres

# Reiniciar PostgreSQL
docker-compose -f .devcontainer/docker-compose.yml restart postgres
```

### Redis não conecta

```bash
# Verificar Redis
docker-compose -f .devcontainer/docker-compose.yml logs redis

# Testar conexão
redis-cli -h redis ping
```

### Gems não instalam

```bash
# Limpar cache de gems
rm -rf /usr/local/bundle
bundle install

# Ou reconstruir o container
F1 > Dev Containers: Rebuild Container
```

### Permissões de arquivo

```bash
# Corrigir permissões
sudo chown -R vscode:vscode /workspaces/todo-ajax-datatable
```

## 🔄 Atualizações

### Adicionar nova gem

1. Adicione a gem no `Gemfile`
2. Execute `bundle install`
3. Reinicie o servidor Rails

### Adicionar nova extensão do VS Code

1. Edite `.devcontainer/devcontainer.json`
2. Adicione o ID da extensão em `customizations.vscode.extensions`
3. Recarregue o container: `F1 > Dev Containers: Rebuild Container`

## 📚 Recursos Adicionais

- [VS Code Dev Containers Documentation](https://code.visualstudio.com/docs/devcontainers/containers)
- [Docker Documentation](https://docs.docker.com/)
- [Rails Guides](https://guides.rubyonrails.org/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Sidekiq Documentation](https://github.com/mperham/sidekiq/wiki)

## 🤝 Contribuindo

Ao fazer melhorias na configuração do DevContainer:

1. Teste completamente as mudanças
2. Documente novas configurações neste README
3. Considere compatibilidade com diferentes sistemas operacionais

## 📄 Licença

Esta configuração faz parte do projeto TODO AJAX DataTable.
