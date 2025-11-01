# Makefile para TODO Ajax DataTable
# Ruby on Rails 5.2.3 + PostgreSQL + Redis + Sidekiq

.PHONY: help install setup start stop restart console db-console clean test lint format coverage assets deploy

# Configurações
BUNDLE = bundle exec
RAILS = $(BUNDLE) rails
RAKE = $(BUNDLE) rake
RSPEC = $(BUNDLE) rspec
RUBOCOP = $(BUNDLE) rubocop
FOREMAN = $(BUNDLE) foreman

# Cores para output
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
NC = \033[0m
BOLD = \033[1m

##@ Geral

help: ## Mostra esta mensagem de ajuda
	@echo ""
	@echo "$(BOLD)TODO Ajax DataTable - Makefile$(NC)"
	@echo ""
	@echo "$(YELLOW)Uso: make [target]$(NC)"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf ""} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2 } /^##@/ { printf "\n$(BOLD)%s$(NC)\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
	@echo ""

##@ Instalação e Setup

install: ## Instala todas as dependências (bundle + yarn)
	@echo "$(GREEN)Instalando dependências...$(NC)"
	bundle install
	yarn install
	@echo "$(GREEN)✓ Dependências instaladas com sucesso!$(NC)"

setup: install db-setup ## Configuração inicial completa do projeto
	@echo "$(GREEN)✓ Setup completo realizado!$(NC)"

update: ## Atualiza as dependências
	@echo "$(YELLOW)Atualizando dependências...$(NC)"
	bundle update
	yarn upgrade
	@echo "$(GREEN)✓ Dependências atualizadas!$(NC)"

##@ Banco de Dados

db-setup: db-create db-migrate db-seed ## Cria, migra e popula o banco de dados
	@echo "$(GREEN)✓ Banco de dados configurado!$(NC)"

db-create: ## Cria o banco de dados
	@echo "$(YELLOW)Criando banco de dados...$(NC)"
	$(RAILS) db:create
	@echo "$(GREEN)✓ Banco criado!$(NC)"

db-migrate: ## Executa as migrations pendentes
	@echo "$(YELLOW)Executando migrations...$(NC)"
	$(RAILS) db:migrate
	@echo "$(GREEN)✓ Migrations executadas!$(NC)"

db-rollback: ## Reverte a última migration
	@echo "$(YELLOW)Revertendo última migration...$(NC)"
	$(RAILS) db:rollback
	@echo "$(GREEN)✓ Migration revertida!$(NC)"

db-seed: ## Popula o banco com dados iniciais
	@echo "$(YELLOW)Populando banco de dados...$(NC)"
	$(RAILS) db:seed
	@echo "$(GREEN)✓ Dados iniciais carregados!$(NC)"

db-reset: ## Reseta o banco de dados (drop + create + migrate + seed)
	@echo "$(RED)Resetando banco de dados...$(NC)"
	$(RAILS) db:drop db:create db:migrate db:seed
	@echo "$(GREEN)✓ Banco resetado!$(NC)"

db-console: ## Abre o console do banco de dados
	$(RAILS) dbconsole

db-status: ## Mostra o status das migrations
	$(RAILS) db:migrate:status

##@ Servidor e Processos

start: ## Inicia o servidor Rails e Sidekiq (via Foreman)
	@echo "$(GREEN)Iniciando servidor e workers...$(NC)"
	$(FOREMAN) start

start-web: ## Inicia apenas o servidor Rails
	@echo "$(GREEN)Iniciando servidor Rails...$(NC)"
	$(RAILS) server -b 0.0.0.0 -p 3000

start-worker: ## Inicia apenas o Sidekiq
	@echo "$(GREEN)Iniciando Sidekiq worker...$(NC)"
	$(BUNDLE) sidekiq -C config/sidekiq.yml

start-dev: ## Inicia em modo desenvolvimento (detached)
	@echo "$(GREEN)Iniciando em modo desenvolvimento...$(NC)"
	$(FOREMAN) start -f Procfile.dev

stop: ## Para todos os processos Rails e Sidekiq
	@echo "$(YELLOW)Parando processos...$(NC)"
	-pkill -f 'rails server' || true
	-pkill -f 'sidekiq' || true
	@echo "$(GREEN)✓ Processos parados!$(NC)"

restart: stop start ## Reinicia o servidor e workers

console: ## Abre o console Rails
	$(RAILS) console

c: console ## Alias para console

##@ Testes

test: ## Executa todos os testes
	@echo "$(YELLOW)Executando testes...$(NC)"
	$(RSPEC)

test-fast: ## Executa testes sem coverage
	@echo "$(YELLOW)Executando testes rápidos...$(NC)"
	COVERAGE=false $(RSPEC)

test-unit: ## Executa apenas testes unitários (models, jobs, services)
	@echo "$(YELLOW)Executando testes unitários...$(NC)"
	$(RSPEC) spec/models spec/jobs spec/services

test-integration: ## Executa testes de integração (controllers, requests)
	@echo "$(YELLOW)Executando testes de integração...$(NC)"
	$(RSPEC) spec/controllers spec/requests

test-watch: ## Executa testes em modo watch
	@echo "$(YELLOW)Executando testes em modo watch...$(NC)"
	$(BUNDLE) guard

test-file: ## Executa um arquivo de teste específico (uso: make test-file FILE=spec/models/todo_spec.rb)
	@echo "$(YELLOW)Executando teste: $(FILE)$(NC)"
	$(RSPEC) $(FILE)

coverage: ## Gera relatório de cobertura de testes
	@echo "$(YELLOW)Gerando relatório de cobertura...$(NC)"
	COVERAGE=true $(RSPEC)
	@echo "$(GREEN)✓ Relatório gerado em coverage/index.html$(NC)"
	@command -v xdg-open > /dev/null && xdg-open coverage/index.html || open coverage/index.html || echo "Abra coverage/index.html no navegador"

##@ Lint e Formatação

lint: ## Executa Rubocop (análise estática)
	@echo "$(YELLOW)Executando Rubocop...$(NC)"
	$(RUBOCOP)

lint-fix: ## Executa Rubocop com auto-correção
	@echo "$(YELLOW)Executando Rubocop com auto-correção...$(NC)"
	$(RUBOCOP) -a

lint-fix-all: ## Executa Rubocop com auto-correção (incluindo unsafe)
	@echo "$(YELLOW)Executando Rubocop com auto-correção completa...$(NC)"
	$(RUBOCOP) -A

lint-generate: ## Gera arquivo .rubocop_todo.yml
	@echo "$(YELLOW)Gerando .rubocop_todo.yml...$(NC)"
	$(RUBOCOP) --auto-gen-config
	@echo "$(GREEN)✓ Arquivo .rubocop_todo.yml gerado!$(NC)"

format: lint-fix ## Formata o código (alias para lint-fix)

##@ Assets

assets-precompile: ## Compila os assets para produção
	@echo "$(YELLOW)Compilando assets...$(NC)"
	$(RAILS) assets:precompile
	@echo "$(GREEN)✓ Assets compilados!$(NC)"

assets-clean: ## Remove assets compilados
	@echo "$(YELLOW)Limpando assets...$(NC)"
	$(RAILS) assets:clean
	@echo "$(GREEN)✓ Assets limpos!$(NC)"

assets-clobber: ## Remove completamente os assets compilados
	@echo "$(YELLOW)Removendo completamente assets...$(NC)"
	$(RAILS) assets:clobber
	@echo "$(GREEN)✓ Assets removidos!$(NC)"

##@ Limpeza

clean: ## Remove arquivos temporários e logs
	@echo "$(YELLOW)Limpando arquivos temporários...$(NC)"
	rm -rf tmp/cache/*
	rm -rf log/*.log
	rm -rf coverage/
	rm -rf .byebug_history
	@echo "$(GREEN)✓ Arquivos temporários removidos!$(NC)"

clean-all: clean assets-clobber ## Limpeza completa (inclui assets)
	@echo "$(YELLOW)Limpeza completa...$(NC)"
	rm -rf node_modules/
	rm -rf vendor/bundle/
	rm -rf tmp/
	@echo "$(GREEN)✓ Limpeza completa realizada!$(NC)"

clean-test: ## Limpa arquivos de teste
	@echo "$(YELLOW)Limpando arquivos de teste...$(NC)"
	rm -rf spec/examples.txt
	rm -rf tmp/test.log
	@echo "$(GREEN)✓ Arquivos de teste limpos!$(NC)"

##@ Rotas e Informações

routes: ## Lista todas as rotas da aplicação
	$(RAILS) routes

routes-grep: ## Busca rotas (uso: make routes-grep PATTERN=todos)
	$(RAILS) routes | grep -i "$(PATTERN)"

stats: ## Mostra estatísticas do código
	$(RAKE) stats

middleware: ## Lista os middlewares da aplicação
	$(RAKE) middleware

about: ## Mostra informações sobre o ambiente Rails
	$(RAILS) about

##@ Logs

logs: ## Mostra os logs de desenvolvimento
	tail -f log/development.log

logs-test: ## Mostra os logs de teste
	tail -f log/test.log

logs-sidekiq: ## Mostra os logs do Sidekiq
	tail -f log/sidekiq.log

logs-clear: ## Limpa todos os logs
	@echo "$(YELLOW)Limpando logs...$(NC)"
	$(RAKE) log:clear
	@echo "$(GREEN)✓ Logs limpos!$(NC)"

##@ Qualidade e CI

ci: clean-test lint test ## Executa pipeline de CI completo
	@echo "$(GREEN)✓ Pipeline CI executado com sucesso!$(NC)"

security: ## Verifica vulnerabilidades de segurança
	@echo "$(YELLOW)Verificando vulnerabilidades...$(NC)"
	bundle audit check --update || true
	@echo "$(GREEN)✓ Verificação de segurança completa!$(NC)"

outdated: ## Lista gems desatualizadas
	bundle outdated

##@ Docker (se aplicável)

docker-build: ## Constrói a imagem Docker
	docker-compose build

docker-up: ## Sobe os containers Docker
	docker-compose up -d

docker-down: ## Para os containers Docker
	docker-compose down

docker-logs: ## Mostra os logs dos containers
	docker-compose logs -f

docker-shell: ## Abre shell no container Rails
	docker-compose exec web bash

docker-reset: ## Reseta completamente os containers
	docker-compose down -v
	docker-compose up -d
	docker-compose exec web rails db:setup

##@ Utilitários

notes: ## Lista anotações no código (TODO, FIXME, OPTIMIZE)
	$(RAKE) notes

annotate: ## Anota os modelos com schema do banco
	@command -v annotate > /dev/null && $(BUNDLE) annotate --models || echo "Gem annotate não instalada"

brakeman: ## Executa análise de segurança com Brakeman
	@command -v brakeman > /dev/null && $(BUNDLE) brakeman || echo "Gem brakeman não instalada"

##@ Aliases Úteis

s: start ## Alias para start
t: test ## Alias para test
l: lint ## Alias para lint
f: format ## Alias para format
r: routes ## Alias para routes

# Target padrão
.DEFAULT_GOAL := help
