# 📘 Guia de Comandos Makefile

Este documento descreve todos os comandos disponíveis no Makefile do projeto TODO Ajax DataTable.

## 🚀 Início Rápido

```bash
# Ver todos os comandos disponíveis
make help

# Setup inicial do projeto
make setup

# Iniciar o servidor
make start
```

## 📋 Categorias de Comandos

### Geral
- `make help` - Mostra a ajuda com todos os comandos disponíveis

### Instalação e Setup
- `make install` - Instala dependências (bundle + yarn)
- `make setup` - Setup completo (install + db-setup)
- `make update` - Atualiza todas as dependências

### Banco de Dados
- `make db-setup` - Configura o banco (create + migrate + seed)
- `make db-create` - Cria o banco de dados
- `make db-migrate` - Executa migrations pendentes
- `make db-rollback` - Reverte a última migration
- `make db-seed` - Popula com dados iniciais
- `make db-reset` - Reseta completamente o banco
- `make db-console` - Abre console do PostgreSQL
- `make db-status` - Mostra status das migrations

### Servidor e Processos
- `make start` - Inicia servidor Rails + Sidekiq (Foreman)
- `make start-web` - Inicia apenas o servidor Rails
- `make start-worker` - Inicia apenas o Sidekiq
- `make start-dev` - Inicia em modo desenvolvimento
- `make stop` - Para todos os processos
- `make restart` - Reinicia servidor e workers
- `make console` - Abre console Rails
- `make c` - Alias para console

### Testes
- `make test` - Executa todos os testes
- `make test-fast` - Testes sem coverage (mais rápido)
- `make test-unit` - Apenas testes unitários
- `make test-integration` - Apenas testes de integração
- `make test-file FILE=spec/path/file_spec.rb` - Testa arquivo específico
- `make coverage` - Gera relatório de cobertura

### Lint e Formatação
- `make lint` - Executa Rubocop
- `make lint-fix` - Rubocop com auto-correção
- `make lint-fix-all` - Rubocop com auto-correção completa
- `make lint-generate` - Gera .rubocop_todo.yml
- `make format` - Formata código (alias de lint-fix)

### Assets
- `make assets-precompile` - Compila assets para produção
- `make assets-clean` - Remove assets compilados
- `make assets-clobber` - Remove completamente os assets

### Limpeza
- `make clean` - Remove temporários e logs
- `make clean-all` - Limpeza completa (inclui node_modules)
- `make clean-test` - Limpa arquivos de teste

### Rotas e Informações
- `make routes` - Lista todas as rotas
- `make routes-grep PATTERN=todos` - Busca rotas específicas
- `make stats` - Estatísticas do código
- `make middleware` - Lista middlewares
- `make about` - Informações do ambiente Rails

### Logs
- `make logs` - Tail dos logs de desenvolvimento
- `make logs-test` - Tail dos logs de teste
- `make logs-sidekiq` - Tail dos logs do Sidekiq
- `make logs-clear` - Limpa todos os logs

### Qualidade e CI
- `make ci` - Pipeline completo (lint + test)
- `make security` - Verifica vulnerabilidades
- `make outdated` - Lista gems desatualizadas

### Docker
- `make docker-build` - Constrói imagem Docker
- `make docker-up` - Sobe containers
- `make docker-down` - Para containers
- `make docker-logs` - Logs dos containers
- `make docker-shell` - Shell no container
- `make docker-reset` - Reseta containers

### Utilitários
- `make notes` - Lista TODOs no código
- `make annotate` - Anota modelos com schema
- `make brakeman` - Análise de segurança

### Aliases Úteis
- `make s` → `make start`
- `make t` → `make test`
- `make l` → `make lint`
- `make f` → `make format`
- `make r` → `make routes`
- `make c` → `make console`

## 💡 Exemplos de Uso

### Workflow de Desenvolvimento Diário

```bash
# 1. Iniciar o dia
make start

# 2. Fazer alterações no código...

# 3. Rodar testes
make t

# 4. Verificar lint
make l

# 5. Corrigir automaticamente
make f
```

### Setup de Novo Desenvolvedor

```bash
# Clone do repositório
git clone <repo-url>
cd todo-ajax-datatable

# Setup completo
make setup

# Iniciar servidor
make s
```

### Workflow de Testes

```bash
# Testes rápidos durante desenvolvimento
make test-fast

# Testar apenas uma feature
make test-unit

# Testar arquivo específico
make test-file FILE=spec/models/todo_spec.rb

# Gerar relatório completo
make coverage
```

### Workflow de Deploy

```bash
# Verificar qualidade
make ci

# Compilar assets
make assets-precompile

# Deploy...
```

### Manutenção do Banco

```bash
# Resetar banco de desenvolvimento
make db-reset

# Criar nova migration
rails g migration AddFieldToModel field:type

# Aplicar migrations
make db-migrate

# Reverter se necessário
make db-rollback
```

### Debugging

```bash
# Ver logs em tempo real
make logs

# Abrir console Rails
make c

# Abrir console do banco
make db-console

# Ver rotas disponíveis
make r
```

### Limpeza e Manutenção

```bash
# Limpeza básica
make clean

# Limpeza completa (cuidado!)
make clean-all

# Limpar apenas testes
make clean-test

# Atualizar dependências
make update
```

## 🎯 Comandos Mais Usados

| Comando | Descrição | Frequência |
|---------|-----------|-----------|
| `make s` | Iniciar servidor | Diária |
| `make t` | Rodar testes | Diária |
| `make l` | Verificar lint | Diária |
| `make c` | Console Rails | Diária |
| `make db-migrate` | Aplicar migrations | Ocasional |
| `make ci` | Pipeline completo | Antes de commit |
| `make routes` | Ver rotas | Ocasional |
| `make clean` | Limpar temporários | Semanal |

## 📝 Notas Importantes

1. **Cores no Terminal**: O Makefile usa cores ANSI para melhor visualização
2. **Aliases**: Use os aliases curtos para agilizar o trabalho
3. **CI Pipeline**: Execute `make ci` antes de fazer push
4. **Help Sempre**: Digite `make` ou `make help` quando esquecer um comando
5. **Customização**: Você pode adicionar novos comandos editando o Makefile

## 🔧 Troubleshooting

### Comando não funciona
```bash
# Verifique se o Make está instalado
make --version

# Verifique se está no diretório correto
pwd
# deve retornar: .../todo-ajax-datatable
```

### Erro de dependências
```bash
# Reinstale tudo
make clean-all
make install
```

### Banco de dados com problemas
```bash
# Resete o banco
make db-reset
```

### Processos não param
```bash
# Force stop
pkill -9 -f 'rails server'
pkill -9 -f 'sidekiq'
```

## 📚 Recursos Adicionais

- [Documentação do Make](https://www.gnu.org/software/make/manual/)
- [Rails Guides](https://guides.rubyonrails.org/)
- [Documentação do projeto](./README.md)

---

**Dica**: Execute `make help` sempre que precisar de uma referência rápida! 🚀
