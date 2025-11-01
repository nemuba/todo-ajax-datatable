# frozen_string_literal: true

require 'database_cleaner/active_record'

RSpec.configure do |config|
  # Configurar Database Cleaner antes da suite de testes
  config.before(:suite) do
    # Usar truncation para garantir limpeza completa
    DatabaseCleaner.clean_with(:truncation)
  end

  # Configurar estratégia padrão para cada teste
  config.before do |example|
    # Para testes que usam JavaScript, Capybara ou jobs em background,
    # usamos truncation porque transaction não funciona com múltiplos threads
    DatabaseCleaner.strategy = if example.metadata[:js] || example.metadata[:type] == :feature
                                 :truncation
                               else
                                 # Para testes normais, transaction é mais rápido
                                 :transaction
                               end

    DatabaseCleaner.start
  end

  # Limpar após cada teste
  config.after do
    DatabaseCleaner.clean
  end
end
