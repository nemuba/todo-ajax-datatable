#!/bin/bash
set -e

echo "🚀 Executando script post-create..."

# Descobrir diretório do workspace (VS Code exporta DEVCONTAINER_WORKSPACE_FOLDER)
WORKSPACE_DIR="${DEVCONTAINER_WORKSPACE_FOLDER:-/workspaces/todo-ajax-datatable}"
cd "$WORKSPACE_DIR"

# Corrigir permissões de volumes montados antes de instalar dependências
echo "🔐 Ajustando permissões dos volumes..."
sudo chown -R vscode:vscode /usr/local/bundle
sudo chown -R vscode:vscode "$WORKSPACE_DIR"

# Instalar dependências Ruby
echo "📦 Instalando gems do Ruby..."
bundle install

# Instalar Foreman globalmente
echo "💎 Instalando Foreman..."
gem install foreman

# Instalar dependências JavaScript
echo "📦 Instalando dependências do Yarn..."
yarn install

# Aguardar PostgreSQL estar pronto
echo "⏳ Aguardando PostgreSQL..."
until pg_isready -h "${DATABASE_HOST:-postgres}" -U "${DATABASE_USERNAME:-postgres}"; do
  echo "Aguardando PostgreSQL iniciar..."
  sleep 2
done

# Aguardar Redis estar pronto
echo "⏳ Aguardando Redis..."
until redis-cli -h "${REDIS_HOST:-redis}" ping > /dev/null 2>&1; do
  echo "Aguardando Redis iniciar..."
  sleep 2
done

# Configurar banco de dados
echo "🗄️  Configurando banco de dados..."
if rails db:version 2>/dev/null; then
  echo "Banco de dados já existe, executando migrations..."
  rails db:migrate
else
  echo "Criando banco de dados..."
  rails db:create
  rails db:migrate

  # Executar seeds se existirem
  if [ -f db/seeds.rb ] && [ -s db/seeds.rb ]; then
    echo "🌱 Executando seeds..."
    rails db:seed
  fi
fi

# Criar banco de dados de teste
echo "🧪 Configurando banco de dados de teste..."
RAILS_ENV=test rails db:create 2>/dev/null || true
RAILS_ENV=test rails db:migrate

# Pré-compilar assets (opcional, descomente se necessário)
# echo "🎨 Pré-compilando assets..."
# rails assets:precompile

# Configurar permissões
echo "🔐 Configurando permissões..."
sudo chown -R vscode:vscode "$WORKSPACE_DIR"
sudo chown -R vscode:vscode /usr/local/bundle

# Criar diretórios necessários
mkdir -p tmp/pids tmp/cache tmp/sockets log storage

echo "✅ Setup completo!"
echo ""
echo "🎉 Seu ambiente está pronto para uso!"
echo ""
echo "📝 Comandos úteis:"
echo "  • rails server -b 0.0.0.0     - Iniciar servidor Rails"
echo "  • bundle exec sidekiq         - Iniciar Sidekiq"
echo "  • rails console               - Console interativo"
echo "  • rails db:migrate            - Executar migrations"
echo "  • bundle exec rspec           - Executar testes"
echo "  • rails routes                - Ver rotas da aplicação"
echo ""
