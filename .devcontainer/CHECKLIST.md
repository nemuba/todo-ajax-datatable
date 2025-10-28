# ✅ Checklist de Verificação - DevContainer

Use este checklist para garantir que a configuração do DevContainer está funcionando corretamente.

## 📋 Antes de Abrir o DevContainer

- [ ] Docker Desktop está instalado e rodando
- [ ] VS Code está atualizado para a versão mais recente
- [ ] Extensão "Dev Containers" está instalada no VS Code
- [ ] Não há containers antigos conflitantes rodando nas portas 3000, 5432, 6379

## 🚀 Primeira Abertura do DevContainer

- [ ] Abriu o projeto no VS Code
- [ ] Executou: `F1 → "Dev Containers: Reopen in Container"`
- [ ] Aguardou a construção da imagem (pode levar 5-10 minutos)
- [ ] Verificou que não houve erros no log de construção

## 🔧 Verificação dos Serviços

### PostgreSQL

- [ ] Container do PostgreSQL está rodando
- [ ] Conexão com o banco está funcionando
- [ ] Extensão pg_trgm foi instalada

**Teste:**

```bash
psql -h db -U postgres -d todo_ajax_datatable_development -c "SELECT * FROM pg_extension WHERE extname='pg_trgm';"
```

### Redis

- [ ] Container do Redis está rodando
- [ ] Conexão com Redis está funcionando

**Teste:**

```bash
redis-cli -h redis ping
# Deve retornar: PONG
```

### Rails

- [ ] Gems foram instaladas com sucesso
- [ ] Banco de dados foi criado
- [ ] Migrações foram executadas
- [ ] Rails console abre sem erros

**Teste:**

```bash
rails console
# Dentro do console:
Todo.count
exit
```

## 📦 Verificação de Dependências

### Ruby

- [ ] Ruby 2.5.3 está instalado
- [ ] Bundler está instalado

**Teste:**

```bash
ruby -v
# Deve mostrar: ruby 2.5.3

bundle -v
# Deve mostrar versão do Bundler
```

### Node.js e Yarn

- [ ] Node.js 14.x está instalado
- [ ] Yarn está instalado
- [ ] Pacotes JavaScript foram instalados

**Teste:**

```bash
node -v
# Deve mostrar: v14.x.x

yarn -v
# Deve mostrar versão do Yarn

ls node_modules/
# Deve listar os pacotes instalados
```

## 🎨 Verificação das Extensões VS Code

- [ ] Extensão Ruby está ativa
- [ ] Extensão Rails está ativa
- [ ] Extensão PostgreSQL está ativa
- [ ] Extensão Docker está ativa

**Verificar:**

```
F1 → "Extensions: Show Installed Extensions"
```

## 🧪 Testes de Funcionalidade

### Servidor Rails

- [ ] Servidor Rails inicia sem erros
- [ ] Aplicação é acessível em <http://localhost:3000>
- [ ] Assets são carregados corretamente

**Teste:**

```bash
rails server -b 0.0.0.0
# Abrir navegador em: http://localhost:3000
```

### Sidekiq

- [ ] Sidekiq inicia sem erros
- [ ] Interface web do Sidekiq é acessível
- [ ] Jobs são processados

**Teste:**

```bash
bundle exec sidekiq -C config/sidekiq.yml
# Abrir navegador em: http://localhost:3000/sidekiq
```

### Testes RSpec

- [ ] RSpec executa sem erros
- [ ] Todos os testes passam (ou pelo menos executam)

**Teste:**

```bash
rspec --format documentation
```

## 🔐 Verificação de Variáveis de Ambiente

- [ ] DATABASE_HOST está definido como "db"
- [ ] POSTGRES_USER está definido
- [ ] POSTGRES_PASSWORD está definido
- [ ] REDIS_URL está definido

**Teste:**

```bash
env | grep -E "(DATABASE|POSTGRES|REDIS)"
```

## 📁 Verificação de Arquivos e Permissões

- [ ] Diretório `.devcontainer/` existe
- [ ] Scripts shell têm permissão de execução
- [ ] Arquivo `.env.example` existe
- [ ] Configurações VS Code foram aplicadas

**Teste:**

```bash
ls -la .devcontainer/
# Scripts .sh devem ter permissão de execução (x)
```

## 🔄 Verificação de Volumes Docker

- [ ] Volume do PostgreSQL foi criado
- [ ] Volume do Redis foi criado
- [ ] Dados persistem após restart do container

**Teste:**

```bash
docker volume ls | grep todo-ajax-datatable
```

## 🌐 Verificação de Rede

- [ ] Containers estão na mesma rede
- [ ] Rails consegue se comunicar com PostgreSQL
- [ ] Rails consegue se comunicar com Redis

**Teste:**

```bash
docker network ls
docker network inspect todo-ajax-datatable_default
```

## 🐛 Testes de Debugging

- [ ] Breakpoints funcionam no VS Code
- [ ] Debug console está acessível
- [ ] Variáveis podem ser inspecionadas

**Teste:**

1. Adicionar breakpoint em um controller
2. Pressionar F5
3. Fazer requisição à rota
4. Verificar se para no breakpoint

## 📊 Verificação de Performance

- [ ] Aplicação carrega rapidamente
- [ ] Não há lentidão perceptível
- [ ] Memória do Docker está adequada
- [ ] CPU não está em 100%

**Monitorar:**

```bash
docker stats
```

## 🔧 Troubleshooting

Se algum item falhou, tente:

### Reconstruir Container

```bash
F1 → "Dev Containers: Rebuild Container"
```

### Resetar Banco de Dados

```bash
rails db:drop db:create db:migrate
```

### Limpar Volumes Docker

```bash
docker-compose -f .devcontainer/docker-compose.yml down -v
docker-compose -f .devcontainer/docker-compose.yml up -d
```

### Reinstalar Dependências

```bash
rm -rf vendor/bundle node_modules
bundle install
yarn install
```

### Verificar Logs

```bash
docker-compose -f .devcontainer/docker-compose.yml logs -f
```

## ✅ Tudo Funcionando?

Se todos os itens acima estão marcados, sua configuração está pronta! 🎉

**Próximos passos:**

1. Consulte [QUICK_START.md](.devcontainer/QUICK_START.md) para começar a desenvolver
2. Veja [COMMANDS.md](.devcontainer/COMMANDS.md) para comandos úteis
3. Leia [README.md](.devcontainer/README.md) para documentação completa

## 📝 Notas Importantes

- Este checklist deve ser executado na **primeira vez** que você abrir o DevContainer
- Se você fizer alterações na configuração, execute novamente este checklist
- Mantenha este arquivo atualizado conforme o projeto evolui

---

**Data da última verificação:** _________________

**Status geral:** ⬜ Todos os testes passaram | ⬜ Alguns testes falharam | ⬜ Não testado

**Observações:**
_____________________________________________________________________________
_____________________________________________________________________________
_____________________________________________________________________________
