# 🎉 Configuração DevContainer - TODO AJAX DataTable

## ✅ Configuração Completa Criada

A configuração completa do DevContainer foi criada para o projeto **TODO AJAX DataTable**.

## 📁 Arquivos Criados

### Diretório `.devcontainer/`

- ✅ `devcontainer.json` - Configuração principal do DevContainer
- ✅ `docker-compose.yml` - Orquestração de serviços (Rails, PostgreSQL, Redis)
- ✅ `Dockerfile` - Imagem personalizada Ruby 2.5.3
- ✅ `init-db.sh` - Script de inicialização do PostgreSQL com pg_trgm
- ✅ `post-create.sh` - Script executado após criação do container
- ✅ `post-start.sh` - Script executado toda vez que o container inicia
- ✅ `.env.example` - Exemplo de variáveis de ambiente
- ✅ `.gitignore` - Ignora arquivos sensíveis do DevContainer
- ✅ `README.md` - Documentação completa do DevContainer
- ✅ `COMMANDS.md` - Guia de comandos úteis
- ✅ `QUICK_START.md` - Guia rápido de início

### Diretório `.vscode/`

- ✅ `extensions.json` - Extensões recomendadas
- ✅ `launch.json` - Configurações de debug
- ✅ `settings.json` - Configurações do editor (atualizado)

### Raiz do Projeto

- ✅ `Procfile.dev` - Para executar Rails + Sidekiq com Foreman
- ✅ `config/database.yml` - Atualizado com variáveis de ambiente do DevContainer

## 🚀 Como Começar

### 1. Pré-requisitos

- Docker Desktop instalado e rodando
- VS Code com extensão "Dev Containers" instalada

### 2. Abrir no DevContainer

```
F1 → "Dev Containers: Reopen in Container"
```

### 3. Aguardar a Inicialização

A primeira vez levará alguns minutos para:

- Construir a imagem Docker
- Instalar Ruby 2.5.3 e dependências
- Instalar gems do projeto
- Instalar pacotes JavaScript (Yarn)
- Criar e migrar o banco de dados

### 4. Iniciar a Aplicação

```bash
# Opção 1: Com Foreman (Rails + Sidekiq)
foreman start -f Procfile.dev

# Opção 2: Apenas Rails
rails server -b 0.0.0.0
```

### 5. Acessar

- Aplicação: <http://localhost:3000>
- Sidekiq Web UI: <http://localhost:3000/sidekiq>

## 🏗️ Arquitetura do DevContainer

```
┌─────────────────────────────────────────────────────────┐
│                     DevContainer                         │
│  ┌────────────────────────────────────────────────────┐ │
│  │  Rails App (Port 3000)                             │ │
│  │  - Ruby 2.5.3                                      │ │
│  │  - Rails 5.2.3                                     │ │
│  │  - Node.js 14.x + Yarn                            │ │
│  │  - Sidekiq Worker                                  │ │
│  └────────────────────────────────────────────────────┘ │
│                                                           │
│  ┌────────────────────────────────────────────────────┐ │
│  │  PostgreSQL 12 (Port 5432)                        │ │
│  │  - Database: todo_ajax_datatable_development      │ │
│  │  - Extension: pg_trgm                             │ │
│  └────────────────────────────────────────────────────┘ │
│                                                           │
│  ┌────────────────────────────────────────────────────┐ │
│  │  Redis (Port 6379)                                │ │
│  │  - Para Sidekiq jobs                              │ │
│  │  - Para ActionCable                               │ │
│  └────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

## 🔧 Serviços Configurados

| Serviço | Versão | Porta | Descrição |
|---------|--------|-------|-----------|
| Ruby | 2.5.3 | - | Linguagem principal |
| Rails | 5.2.3 | 3000 | Framework web |
| PostgreSQL | 12 | 5432 | Banco de dados |
| Redis | 6 | 6379 | Cache e jobs |
| Node.js | 14.x | - | JavaScript runtime |
| Sidekiq | Latest | - | Background jobs |

## 📦 Ferramentas Incluídas

### Desenvolvimento

- Git
- Build essentials (gcc, make, etc.)
- PostgreSQL client
- Redis CLI
- Curl, wget, vim, nano

### Ruby/Rails

- Bundler
- RSpec
- Rubocop (se configurado)
- Foreman

### JavaScript

- Node.js 14.x
- Yarn
- NPM

### Banco de Dados

- PostgreSQL 12 com pg_trgm
- Ferramenta de migração Rails

## 🎨 Extensões VS Code Instaladas

Automaticamente instaladas no DevContainer:

1. **rebornix.ruby** - Suporte à linguagem Ruby
2. **castwide.solargraph** - IntelliSense para Ruby
3. **bung87.rails** - Suporte ao Rails framework
4. **ckolkman.vscode-postgres** - Cliente PostgreSQL
5. **ms-azuretools.vscode-docker** - Gerenciamento Docker
6. **aliariff.vscode-erb-beautify** - Formatação ERB
7. **editorconfig.editorconfig** - EditorConfig support

## 🔐 Variáveis de Ambiente

Configuradas automaticamente:

```bash
DATABASE_HOST=db
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=todo_ajax_datatable_development
REDIS_URL=redis://redis:6379/0
RAILS_ENV=development
```

## 📚 Documentação

- **[QUICK_START.md](.devcontainer/QUICK_START.md)** - Guia rápido para começar
- **[README.md](.devcontainer/README.md)** - Documentação completa
- **[COMMANDS.md](.devcontainer/COMMANDS.md)** - Comandos úteis e workflows

## 🧪 Testes

```bash
# Executar todos os testes
rspec

# Testes específicos
rspec spec/models/todo_spec.rb

# Com cobertura
rspec --format documentation
```

## 🐛 Troubleshooting

### Container não inicia

```bash
# Reconstruir do zero
F1 → "Dev Containers: Rebuild Container"
```

### Banco de dados com problemas

```bash
rails db:drop db:create db:migrate
```

### Permissões de scripts

```bash
chmod +x .devcontainer/*.sh
```

### Ver logs dos serviços

```bash
docker-compose -f .devcontainer/docker-compose.yml logs
```

## 🚧 Próximos Passos

1. **Teste o ambiente:**

   ```bash
   rails console
   Todo.count
   ```

2. **Execute os testes:**

   ```bash
   rspec
   ```

3. **Inicie a aplicação:**

   ```bash
   foreman start -f Procfile.dev
   ```

4. **Acesse:** <http://localhost:3000>

## 💡 Dicas

- Use `Ctrl+`` para abrir o terminal integrado
- Use `F5` para iniciar o debugger
- As configurações do Git são compartilhadas com o host
- Arquivos modificados no container aparecem no host automaticamente

## 📞 Suporte

Em caso de problemas:

1. Consulte [QUICK_START.md](.devcontainer/QUICK_START.md)
2. Veja os logs: `docker-compose logs`
3. Reconstrua o container: `F1 > Rebuild Container`
4. Consulte a documentação oficial: [Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)

---

**Pronto para desenvolvimento!** 🎉

Toda a stack está configurada e pronta para uso. Basta abrir o projeto no DevContainer e começar a desenvolver!
