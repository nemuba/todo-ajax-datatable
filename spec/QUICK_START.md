# Guia Rápido de Testes RSpec

Este guia fornece comandos e exemplos rápidos para começar a usar RSpec no projeto.

## 🚀 Início Rápido

### 1. Executar Todos os Testes

```bash
bundle exec rspec
```

### 2. Executar Testes por Tipo

```bash
# Testes de modelos
bundle exec rspec spec/models

# Testes de controllers
bundle exec rspec spec/controllers

# Teste específico
bundle exec rspec spec/models/todo_spec.rb
```

### 3. Ver Resultados Detalhados

```bash
bundle exec rspec --format documentation
```

## 📝 Criando Testes Rápidos

### Teste de Modelo

```ruby
# spec/models/nome_do_modelo_spec.rb
require 'rails_helper'

RSpec.describe NomeDoModelo, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:campo) }
  end

  describe 'associations' do
    it { should belong_to(:outra_tabela) }
  end

  it 'has a valid factory' do
    objeto = build(:nome_do_modelo)
    expect(objeto).to be_valid
  end
end
```

### Teste de Controller

```ruby
# spec/controllers/nome_controller_spec.rb
require 'rails_helper'

RSpec.describe NomeController, type: :controller do
  describe 'GET #index' do
    it 'returns success' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    it 'creates a new record' do
      expect {
        post :create, params: { objeto: { campo: 'valor' } }
      }.to change(Modelo, :count).by(1)
    end
  end
end
```

## 🏭 Usando Factories

### Criar Objetos de Teste

```ruby
# Criar sem salvar no banco
objeto = build(:todo)

# Criar e salvar no banco
objeto = create(:todo)

# Criar múltiplos objetos
objetos = create_list(:todo, 5)

# Usar traits
objeto_especial = create(:todo, :completed)

# Sobrescrever atributos
objeto = create(:todo, title: 'Título Customizado')
```

### Definir Nova Factory

```ruby
# spec/factories/nome_do_modelo.rb
FactoryBot.define do
  factory :nome_do_modelo do
    campo { Faker::Lorem.word }
    outro_campo { Faker::Number.number(digits: 5) }

    trait :especial do
      campo { 'Valor Especial' }
    end
  end
end
```

## 🎯 Matchers Comuns

### Validações

```ruby
it { should validate_presence_of(:campo) }
it { should validate_uniqueness_of(:email) }
it { should validate_length_of(:senha).is_at_least(6) }
it { should validate_numericality_of(:idade) }
```

### Associações

```ruby
it { should belong_to(:usuario) }
it { should have_many(:items) }
it { should have_many(:items).dependent(:destroy) }
it { should have_one(:perfil) }
```

### Expectativas Gerais

```ruby
expect(objeto).to be_valid
expect(objeto).to be_persisted
expect(objeto.campo).to eq('valor')
expect(objeto.campo).to be_present
expect(objeto.campo).to be_nil
expect(array).to include(item)
expect(response).to be_successful
expect(response).to have_http_status(:ok)
```

### Mudanças

```ruby
expect {
  # ação que causa mudança
}.to change(Model, :count).by(1)

expect {
  # ação
}.to change { objeto.reload.campo }.from('antigo').to('novo')
```

## 🔍 Debugging

### Imprimir Valores Durante Testes

```ruby
it 'debugs values' do
  objeto = create(:todo)
  puts objeto.inspect          # Ver todos os atributos
  puts objeto.errors.full_messages  # Ver erros de validação
  
  # Ou usar binding.pry para debug interativo
  # binding.pry
  
  expect(objeto).to be_valid
end
```

### Ver Queries SQL

```ruby
it 'shows SQL queries' do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  
  create(:todo)
  
  ActiveRecord::Base.logger = nil
end
```

## 📊 Cobertura de Código

Após executar os testes, abra o relatório de cobertura:

```bash
# Executar testes
bundle exec rspec

# Abrir relatório (macOS)
open coverage/index.html

# Abrir relatório (Linux)
xdg-open coverage/index.html
```

## ⚡ Dicas Rápidas

### Executar Apenas Testes que Falharam

```bash
bundle exec rspec --only-failures
```

### Executar Teste Específico por Linha

```bash
bundle exec rspec spec/models/todo_spec.rb:15
```

### Executar em Ordem Aleatória

```bash
bundle exec rspec --order random
```

### Ver 10 Testes Mais Lentos

```bash
bundle exec rspec --profile
```

## 🆘 Problemas Comuns

### Erro: "Factory not registered"

**Solução:** Verifique se a factory está definida em `spec/factories/` com o nome correto.

### Erro: "Database cleaner not configured"

**Solução:** Já está configurado em `rails_helper.rb`, mas verifique se o arquivo está sendo carregado.

### Testes Falhando Aleatoriamente

**Solução:** Provavelmente há dependência entre testes. Execute com `--order random` para identificar.

### Erro: "Validation failed"

**Solução:** Use `puts objeto.errors.full_messages` para ver quais validações estão falhando.

## 📚 Recursos

- [Guia Completo](spec/README.md) - Documentação detalhada
- [RSpec Docs](https://rspec.info/) - Documentação oficial
- [FactoryBot](https://github.com/thoughtbot/factory_bot) - Gem para factories
- [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers) - Matchers extras

## 💡 Exemplos do Projeto

Veja os arquivos existentes para exemplos práticos:

- `spec/models/todo_spec.rb` - Exemplo de teste de modelo
- `spec/models/item_spec.rb` - Exemplo de teste de modelo com associação
- `spec/controllers/todos_controller_spec.rb` - Exemplo de teste de controller
- `spec/factories/todos.rb` - Exemplo de factory com traits
- `spec/factories/items.rb` - Exemplo de factory com associação
