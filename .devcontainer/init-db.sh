#!/bin/bash
set -e

# Script de inicialização do PostgreSQL
# Cria extensão pg_trgm necessária para busca textual

echo "Inicializando banco de dados PostgreSQL..."

# Criar banco de dados de desenvolvimento
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "ajax-jquery-crud_development" <<-EOSQL
    -- Criar extensão pg_trgm para busca textual eficiente
    CREATE EXTENSION IF NOT EXISTS pg_trgm;

    -- Criar extensão unaccent para remover acentos em buscas (opcional)
    CREATE EXTENSION IF NOT EXISTS unaccent;

    -- Confirmar instalação
    SELECT extname, extversion FROM pg_extension WHERE extname IN ('pg_trgm', 'unaccent');
EOSQL

# Criar banco de dados de teste
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE DATABASE "ajax-jquery-crud_test";
EOSQL

# Adicionar extensões no banco de teste
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "ajax-jquery-crud_test" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS pg_trgm;
    CREATE EXTENSION IF NOT EXISTS unaccent;
EOSQL

echo "✓ Banco de dados PostgreSQL inicializado com sucesso!"
echo "✓ Extensões pg_trgm e unaccent instaladas"
