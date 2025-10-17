# Guia de Testes com RSpec

Este guia fornece informações detalhadas sobre como executar e escrever testes para o projeto TODO AJAX DataTable.

## Índice

- [Configuração](#configuração)
- [Executando os Testes](#executando-os-testes)
- [Estrutura dos Testes](#estrutura-dos-testes)
- [Escrevendo Testes](#escrevendo-testes)
- [Melhores Práticas](#melhores-práticas)

## Configuração

### Gems de Teste

O projeto utiliza as seguintes gems para testes:

- **rspec-rails**: Framework de testes para Rails
- **factory_bot_rails**: Criação de objetos para testes
- **shoulda-matchers**: Matchers adicionais para testes de validações e associações
- **database_cleaner-active_record**: Limpa o banco de dados entre os testes
- **simplecov**: Relatórios de cobertura de código
- **faker**: Geração de dados aleatórios para testes

### Arquivos de Configuração

- `.rspec`: Configurações da linha de comando do RSpec
- `spec/spec_helper.rb`: Configurações gerais do RSpec
- `spec/rails_helper.rb`: Configurações específicas do Rails
- `spec/support/`: Arquivos de suporte adicionais

## Executando os Testes

### Comandos Básicos

```bash
# Executar todos os testes
bundle exec rspec

# Executar testes de um diretório específico
bundle exec rspec spec/models
bundle exec rspec spec/controllers

# Executar um arquivo específico
bundle exec rspec spec/models/todo_spec.rb

# Executar um teste específico (por linha)
bundle exec rspec spec/models/todo_spec.rb:10

# Executar com formatação detalhada
bundle exec rspec --format documentation

# Executar apenas testes que falharam na última execução
bundle exec rspec --only-failures

# Executar em ordem aleatória (para detectar dependências entre testes)
bundle exec rspec --order random
```

### Cobertura de Código

O SimpleCov gera automaticamente relatórios de cobertura ao executar os testes:

```bash
# Executar testes com cobertura
bundle exec rspec

# Visualizar relatório (após executar os testes)
open coverage/index.html  # macOS
xdg-open coverage/index.html  # Linux
```

O relatório mostra:
- Porcentagem de cobertura total
- Arquivos com baixa cobertura
- Linhas não cobertas por testes

## Estrutura dos Testes

```
spec/
├── factories/              # Factories para criar objetos de teste
│   ├── todos.rb           # Factory para modelo Todo
│   └── items.rb           # Factory para modelo Item
│
├── models/                # Testes de modelos
│   ├── todo_spec.rb       # Testes do modelo Todo
│   └── item_spec.rb       # Testes do modelo Item
│
├── controllers/           # Testes de controllers
│   └── todos_controller_spec.rb
│
├── requests/              # Testes de integração (request specs)
│   └── (adicionar conforme necessário)
│
├── support/               # Arquivos de suporte
│   ├── factory_bot.rb     # Configuração do FactoryBot
│   └── simplecov.rb       # Configuração do SimpleCov
│
├── rails_helper.rb        # Configuração Rails
└── spec_helper.rb         # Configuração geral
```

## Escrevendo Testes

### Testes de Modelos

Os testes de modelos devem cobrir:
- Validações
- Associações
- Métodos customizados
- Callbacks
- Scopes

**Exemplo:**

```ruby
# spec/models/todo_spec.rb
require 'rails_helper'

RSpec.describe Todo, type: :model do
  # Testes de validações
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end

  # Testes de associações
  describe 'associations' do
    it { should have_many(:items).dependent(:destroy) }
  end

  # Testes de factory
  describe 'factory' do
    it 'has a valid factory' do
      todo = build(:todo)
      expect(todo).to be_valid
    end
  end

  # Testes de métodos customizados
  describe '#done?' do
    context 'when todo is completed' do
      it 'returns true' do
        todo = create(:todo, :completed)
        expect(todo.done).to be true
      end
    end
  end
end
```

### Testes de Controllers

Os testes de controllers devem cobrir:
- Respostas HTTP (status codes)
- Renderização de views/templates
- Atribuição de variáveis de instância
- Redirecionamentos
- Alterações no banco de dados

**Exemplo:**

```ruby
# spec/controllers/todos_controller_spec.rb
require 'rails_helper'

RSpec.describe TodosController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns all todos to @todos' do
      todo = create(:todo)
      get :index, format: :json
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_attributes) { { title: 'Test', description: 'Test' } }

      it 'creates a new Todo' do
        expect {
          post :create, params: { todo: valid_attributes }, format: :js
        }.to change(Todo, :count).by(1)
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { { title: '', description: '' } }

      it 'does not create a new Todo' do
        expect {
          post :create, params: { todo: invalid_attributes }, format: :js
        }.to change(Todo, :count).by(0)
      end
    end
  end
end
```

### Usando Factories

**Criando Objetos:**

```ruby
# Criar objeto sem salvar no banco
todo = build(:todo)

# Criar objeto e salvar no banco
todo = create(:todo)

# Criar múltiplos objetos
todos = create_list(:todo, 3)

# Usar traits
completed_todo = create(:todo, :completed)
todo_with_items = create(:todo, :with_items)

# Sobrescrever atributos
todo = create(:todo, title: 'Custom Title')
```

**Definindo Factories:**

```ruby
# spec/factories/todos.rb
FactoryBot.define do
  factory :todo do
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
    done { false }

    # Traits para variações
    trait :completed do
      done { true }
    end

    trait :with_items do
      after(:create) do |todo|
        create_list(:item, 3, todo: todo)
      end
    end
  end
end
```

## Melhores Práticas

### 1. Organização dos Testes

- Use `describe` para agrupar testes relacionados
- Use `context` para diferentes cenários
- Use nomes descritivos para os testes

```ruby
describe '#method_name' do
  context 'when condition is true' do
    it 'does something' do
      # teste
    end
  end

  context 'when condition is false' do
    it 'does something else' do
      # teste
    end
  end
end
```

### 2. Use let e let!

```ruby
# let: lazy-loaded (apenas quando usado)
let(:todo) { create(:todo) }

# let!: eager-loaded (criado imediatamente)
let!(:todo) { create(:todo) }
```

### 3. DRY (Don't Repeat Yourself)

Use `before` blocks para setup comum:

```ruby
describe TodosController do
  let(:todo) { create(:todo) }

  before do
    sign_in user  # se houver autenticação
  end

  describe 'GET #show' do
    # teste
  end
end
```

### 4. Teste Uma Coisa por Vez

Cada teste deve verificar apenas um comportamento:

```ruby
# ❌ Ruim - testa múltiplas coisas
it 'creates todo and sends email' do
  expect { post :create }.to change(Todo, :count).by(1)
  expect(ActionMailer::Base.deliveries.count).to eq(1)
end

# ✅ Bom - testes separados
it 'creates a new todo' do
  expect { post :create }.to change(Todo, :count).by(1)
end

it 'sends confirmation email' do
  post :create
  expect(ActionMailer::Base.deliveries.count).to eq(1)
end
```

### 5. Use Matchers Apropriados

```ruby
# Shoulda Matchers para validações
it { should validate_presence_of(:title) }
it { should validate_uniqueness_of(:email) }
it { should validate_length_of(:password).is_at_least(6) }

# Associações
it { should belong_to(:user) }
it { should have_many(:items).dependent(:destroy) }

# RSpec matchers
expect(todo).to be_valid
expect(todo.done).to be true
expect(response).to be_successful
expect(Todo.count).to eq(5)
```

### 6. Teste Edge Cases

- Valores nulos
- Strings vazias
- Valores extremos
- Condições de erro

### 7. Evite Testes Frágeis

- Não dependa da ordem de execução
- Limpe dados entre testes (DatabaseCleaner faz isso)
- Use factories em vez de fixtures

### 8. Mantenha Testes Rápidos

- Use `build` em vez de `create` quando possível
- Mock serviços externos
- Evite sleep e wait desnecessários

## Recursos Adicionais

- [RSpec Documentation](https://rspec.info/)
- [FactoryBot Documentation](https://github.com/thoughtbot/factory_bot)
- [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers)
- [Better Specs](http://www.betterspecs.org/)
- [RSpec Style Guide](https://github.com/rubocop/rspec-style-guide)
