#!/bin/bash
set -e

echo "🔄 Executando script post-start..."

WORKSPACE_DIR="${DEVCONTAINER_WORKSPACE_FOLDER:-/workspaces/todo-ajax-datatable}"
cd "$WORKSPACE_DIR"

# Limpar arquivos temporários antigos
echo "🧹 Limpando arquivos temporários..."
rm -f tmp/pids/server.pid 2>/dev/null || true
rm -rf tmp/cache/* 2>/dev/null || true

# Verificar conexão com serviços
echo "🔍 Verificando conexões..."

# PostgreSQL
if pg_isready -h "${DATABASE_HOST:-postgres}" -U "${DATABASE_USERNAME:-postgres}" > /dev/null 2>&1; then
  echo "✓ PostgreSQL conectado"
else
  echo "⚠ PostgreSQL não está respondendo"
fi

# Redis
if redis-cli -h "${REDIS_HOST:-redis}" ping > /dev/null 2>&1; then
  echo "✓ Redis conectado"
else
  echo "⚠ Redis não está respondendo"
fi

# Atualizar gems se necessário (opcional)
# bundle check || bundle install

echo "✅ Ambiente pronto!"
echo ""
echo "💡 Dica: Use 'rails server -b 0.0.0.0' para iniciar o servidor Rails"
echo "💡 Dica: Use 'bundle exec sidekiq' em outro terminal para processar jobs"
echo ""
