# frozen_string_literal: true

# Helper para testes que precisam desabilitar proteção CSRF
RSpec.configure do |config|
  config.before(:each, type: :request) do
    # Desabilita verificação de CSRF token para testes de request
    # porque os testes XHR não incluem automaticamente o token
    ActionController::Base.allow_forgery_protection = false
  end

  config.after(:each, type: :request) do
    # Reabilita a proteção após cada teste
    ActionController::Base.allow_forgery_protection = true
  end
end
