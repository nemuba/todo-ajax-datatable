#!/bin/bash
set -e

echo "🔄 Executando script post-start..."

WORKSPACE_DIR="${DEVCONTAINER_WORKSPACE_FOLDER:-/workspaces/todo-ajax-datatable}"
cd "$WORKSPACE_DIR"

# Verificar se o agente SSH está funcionando
if [ -S "$SSH_AUTH_SOCK" ]; then
    echo "✅ SSH Agent detectado"
else
    echo "⚠️  SSH Agent não detectado. Configurando..."
    eval "$(ssh-agent -s)"

    # Tentar adicionar chaves SSH padrão
    for key in ~/.ssh/id_rsa ~/.ssh/id_ed25519; do
        if [ -f "$key" ]; then
            ssh-add "$key" 2>/dev/null && echo "🔑 Chave $key adicionada"
        fi
    done
fi

# Verificar conectividade com GitHub
echo "🔍 Testando conexão com GitHub..."
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo "✅ Autenticação com GitHub funcionando"
else
    echo "⚠️  Problema na autenticação com GitHub"
    echo "💡 Execute: ssh -T git@github.com para diagnosticar"
fi

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
