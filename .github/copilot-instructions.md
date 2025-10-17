# Instruções para trabalho com o TODO AJAX DataTable

## Visão Geral do Projeto

Este é um aplicativo Ruby on Rails (5.2.3) moderno que implementa um sistema completo de gerenciamento de tarefas (TODOs) com funcionalidades avançadas. É um excelente exemplo de como construir aplicações Rails escaláveis com interface rica.

### Características Principais
- **Interface moderna**: AJAX + DataTables para experiência fluida
- **Processamento assíncrono**: Sidekiq para operações pesadas
- **Comunicação em tempo real**: ActionCable para feedback instantâneo
- **Múltiplos formatos**: Exportação para CSV, PDF, DOCX, XLSX
- **Performance otimizada**: Índices PostgreSQL com pg_trgm para busca textual

## Arquitetura e Componentes

### Stack Tecnológico
- **Backend**: Ruby 2.5.3, Rails 5.2.3, PostgreSQL
- **Frontend**: Bootstrap 4.3.1, jQuery, DataTables
- **Processamento**: Sidekiq + Redis
- **Comunicação**: ActionCable para WebSockets

### Estrutura de Dados
```
TODOs (1:N) → ITEMS
├── Todo: title, description, done
└── Item: description, status, todo_id
```

### Componentes da Arquitetura
- **Models**: Todo e Item com relacionamento pai-filho (1:N)
- **Controllers**: TodosController com funcionalidades CRUD completas
- **DataTables**: Renderização de tabelas interativas via ajax-datatables-rails
- **Decorators**: Usando Draper para separação da lógica de apresentação
- **Jobs**: ImportJob e DeleteAllJob para processamento assíncrono
- **Channels**: ImportChannel e DeleteAllChannel para comunicação em tempo real
- **Services**: TodoService para lógica de negócio complexa

## Padrões e Convenções Importantes

### Convenções de Código Ruby/Rails
- Seguir Ruby Style Guide e Rails conventions
- Usar `frozen_string_literal: true` em todos os arquivos
- Modelos com validações explícitas e associações bem definidas
- Controllers RESTful com responsabilidades bem definidas
- Decorators para separar lógica de apresentação dos modelos

### Padrão de DataTables
A aplicação usa DataTables para apresentação tabular avançada:

**Configuração do lado servidor:**
```ruby
# app/datatables/todo_datatable.rb - Classe Ruby para configuração
class TodoDatatable < AjaxDatatablesRails::ActiveRecord
  def view_columns
    @view_columns ||= {
      id: { source: 'Todo.id', cond: :eq },
      title: { source: 'Todo.title', cond: :like },
      description: { source: 'Todo.description', cond: :like }
    }
  end
end

# Em controllers
format.json { render json: TodoDatatable.new(params, view_context: view_context) }
```

**Configuração do lado cliente:**
```erb
<!-- Em views -->
<%= datatable_ajax(id: 'todos', url: todos_path(format: :json)) do %>
  <tfoot>
    <tr>
      <th></th>
      <th>ID</th>
      <th>Título</th>
      <th>Ações</th>
    </tr>
  </tfoot>
<% end %>
```

**JavaScript para DataTables:**
```javascript
// app/assets/javascripts/datatables.js - Configuração do cliente
App.DataTable = {
  init: function() {
    $('#todos').DataTable({
      processing: true,
      serverSide: true,
      ajax: {
        url: $('#todos').data('source'),
        type: 'GET'
      }
    });
  }
}
```

### Padrão de Processamento Assíncrono
A aplicação usa Sidekiq para operações pesadas com feedback em tempo real:

**Configuração de Jobs:**
```ruby
# app/jobs/import_job.rb
class ImportJob < ApplicationJob
  queue_as :default

  def perform(file)
    # Processamento pesado
    import_channel("Processamento concluído", 'success')
  end

  private

  def import_channel(message, type = 'success')
    ActionCable.server.broadcast('import_channel', {
      message: message,
      type: type
    })
  end
end
```

**Comunicação em tempo real:**
```javascript
// app/assets/javascripts/channels/import_channel.js
App.cable.subscriptions.create("ImportChannel", {
  received: function(data) {
    Alert.show(data.type, data.message);
  }
});
```

### Padrão de Exportação de Documentos
Sistema flexível para exportar dados em múltiplos formatos:

```ruby
# app/controllers/concerns/export_document.rb
module ExportDocument
  def render_data(format, data)
    case format
    when :pdf
      render pdf: filename('pdf'),
             template: 'todos/exports/pdf',
             locals: data
    when :xlsx
      render xlsx: filename('xlsx'),
             template: 'todos/exports/xlsx',
             locals: data
    end
  end
end

# No controller
format.csv { send_data Todo.to_csv, filename: filename('csv') }
format.pdf { render_data(:pdf, { todos: Todo.includes(:items).all }) }
format.docx { render_data(:docx, { todos: Todo.includes(:items).all }) }
format.xlsx { render_data(:xlsx, { todos: Todo.includes(:items).all }) }
```

### Padrão de Decorators (Draper)
Separação da lógica de apresentação usando o padrão Decorator:

```ruby
# app/decorators/todo_decorator.rb
class TodoDecorator < ApplicationDecorator
  def done_badge
    icon = object.done ? h.icon_solid { 'fa-check' } : h.icon_solid { 'fa-times' }
    h.content_tag(:span, icon, class: "badge badge-#{object.done ? 'success' : 'danger'}")
  end

  def formatted_date(attribute)
    to_format(object.send(attribute), '%d/%m/%Y')
  end

  def action_buttons
    h.content_tag(:div, class: 'btn-group') do
      [btn_show, btn_edit, btn_destroy].join(' ').html_safe
    end
  end
end

# Uso nas views e DataTables
record.decorate.done_badge
record.decorate.formatted_date(:created_at)
```

### Padrão de JavaScript Namespaced
Organização modular do código JavaScript:

```javascript
// Estrutura de namespaces
const App = window.App || {};

App.Todo = {
  destroy: (element) => {
    Alert.confirm('Confirmar exclusão?').then((result) => {
      if (result.value) {
        $.ajax({
          url: element.dataset.source,
          method: element.dataset.method,
          success: () => App.Todo.refreshDataTable()
        });
      }
    });
  },

  refreshDataTable: () => {
    $('#todos').DataTable().ajax.reload();
  }
};

App.Modal = Modal.init();
```

## Fluxos de Desenvolvimento

### Configurando o Ambiente de Desenvolvimento

**Pré-requisitos:**
- Ruby 2.5.3 (considere usar rbenv ou rvm)
- PostgreSQL 10+ com extensão pg_trgm
- Redis (para Sidekiq)
- Node.js e Yarn (para assets)

**Passos de configuração:**
```bash
# 1. Instalar dependências Ruby
bundle install

# 2. Instalar dependências JavaScript
yarn install

# 3. Configurar banco de dados
rails db:create
rails db:migrate
rails db:seed  # Se houver seeds

# 4. Compilar assets (desenvolvimento)
rails assets:precompile  # Se necessário

# 5. Iniciar serviços de desenvolvimento
# Terminal 1: Redis
redis-server

# Terminal 2: Sidekiq
bundle exec sidekiq

# Terminal 3: Rails server
rails server

# Ou usar Foreman (se configurado)
foreman start
```

**Verificação do ambiente:**
- Aplicação: http://localhost:3000
- Sidekiq Web UI: http://localhost:3000/sidekiq
- ActionCable: ws://localhost:3000/cable

### Estrutura de Testes

O projeto usa RSpec para testes. Estrutura recomendada:

```ruby
# spec/rails_helper.rb - Configuração principal
require 'spec_helper'
require 'factory_bot_rails'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.use_transactional_fixtures = true
end

# spec/models/todo_spec.rb
RSpec.describe Todo, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end

  describe 'associations' do
    it { should have_many(:items).dependent(:destroy) }
  end
end

# spec/factories/todos.rb
FactoryBot.define do
  factory :todo do
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
    done { false }

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

**Comandos de teste:**
```bash
# Executar todos os testes
bundle exec rspec

# Executar testes específicos
bundle exec rspec spec/models/
bundle exec rspec spec/controllers/todos_controller_spec.rb

# Com coverage
bundle exec rspec --format documentation
```

### Fluxo de Desenvolvimento de Features

**1. Análise da Feature:**
- Identifique se precisa de novos modelos, controllers ou views
- Determine se requer processamento assíncrono
- Verifique se precisa de comunicação em tempo real

**2. Desenvolvimento Backend:**
```ruby
# Exemplo: Nova funcionalidade de categorias
# 1. Gerar migration
rails generate migration AddCategoryToTodos category:string

# 2. Atualizar modelo
class Todo < ApplicationRecord
  validates :category, presence: true
  scope :by_category, ->(category) { where(category: category) }
end

# 3. Atualizar controller
def index
  @categories = Todo.distinct.pluck(:category)
  # ... resto do código
end

# 4. Atualizar DataTable
def view_columns
  @view_columns ||= {
    # ... colunas existentes
    category: { source: 'Todo.category', cond: :like }
  }
end
```

**3. Desenvolvimento Frontend:**
```javascript
// Atualizar JavaScript se necessário
App.Todo.filterByCategory = (category) => {
  const table = $('#todos').DataTable();
  table.column(3).search(category).draw(); // Coluna da categoria
};
```

**4. Testes:**
```ruby
# Adicionar testes para nova funcionalidade
describe 'category filtering' do
  let!(:todo_work) { create(:todo, category: 'work') }
  let!(:todo_personal) { create(:todo, category: 'personal') }

  it 'filters todos by category' do
    expect(Todo.by_category('work')).to include(todo_work)
    expect(Todo.by_category('work')).not_to include(todo_personal)
  end
end
```

### Debugging e Monitoramento

**Logs importantes:**
```bash
# Logs da aplicação
tail -f log/development.log

# Logs do Sidekiq
tail -f log/sidekiq.log

# Logs do PostgreSQL (Ubuntu)
sudo tail -f /var/log/postgresql/postgresql-*.log
```

**Debugging com binding.pry:**
```ruby
# Em qualquer lugar do código Rails
require 'pry'
binding.pry
```

**Monitoramento Sidekiq:**
- Web UI: http://localhost:3000/sidekiq
- CLI: `bundle exec sidekiq -v` para informações

**Performance do banco:**
```sql
-- Verificar queries lentas
SELECT query, mean_time, calls
FROM pg_stat_statements
ORDER BY mean_time DESC LIMIT 10;

-- Verificar índices não utilizados
SELECT * FROM pg_stat_user_indexes WHERE idx_scan = 0;
```

## Boas Práticas e Padrões Específicos

### Tratamento de Erros e Validações

**Backend (Models):**
```ruby
class Todo < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true

  # Validações customizadas
  validate :title_cannot_be_duplicate_when_active

  private

  def title_cannot_be_duplicate_when_active
    return unless done == false

    if Todo.where.not(id: id).exists?(title: title, done: false)
      errors.add(:title, 'já existe uma tarefa ativa com este título')
    end
  end
end
```

**Frontend (JavaScript):**
```javascript
// Tratamento de erros AJAX padronizado
App.Ajax = {
  handleError: (xhr, status, error) => {
    if (xhr.status === 422) {
      const errors = xhr.responseJSON.errors;
      let errorMessage = 'Erro ao processar a solicitação:';
      for (const key in errors) {
        errorMessage += `\n${key}: ${errors[key].join(', ')}`;
      }
      Alert.error('Erro de Validação', errorMessage);
    } else if (xhr.status === 500) {
      Alert.error('Erro do Servidor', 'Erro interno. Contate o administrador.');
    } else {
      Alert.error('Erro', 'Ocorreu um erro inesperado. Tente novamente.');
    }
  }
};

// Uso em requests AJAX
$.ajax({
  url: '/todos',
  method: 'POST',
  data: formData,
  success: (response) => { /* sucesso */ },
  error: App.Ajax.handleError
});
```

### Performance e Otimização

**Queries eficientes:**
```ruby
# ❌ N+1 Query Problem
todos = Todo.all
todos.each { |todo| puts todo.items.count }

# ✅ Eager Loading
todos = Todo.includes(:items)
todos.each { |todo| puts todo.items.size }

# ✅ Counter Cache (se apropriado)
class Todo < ApplicationRecord
  has_many :items, dependent: :destroy
end

class Item < ApplicationRecord
  belongs_to :todo, counter_cache: true
end
```

**Uso de índices:**
```ruby
# migration para otimização de busca
class AddIndexesToTodos < ActiveRecord::Migration[5.2]
  def change
    # Índice GIN para busca textual full-text
    add_index :todos, :title, using: :gin, opclass: :gin_trgm_ops
    add_index :todos, :description, using: :gin, opclass: :gin_trgm_ops

    # Índice composto para queries frequentes
    add_index :todos, [:done, :created_at]
  end
end
```

**Paginação eficiente no DataTable:**
```ruby
class TodoDatatable < AjaxDatatablesRails::ActiveRecord
  private

  def get_raw_records
    Todo.includes(:items)
        .joins(:items) # Se necessário
        .select('todos.*, COUNT(items.id) as items_count')
        .group('todos.id')
  end
end
```

### Segurança

**Strong Parameters:**
```ruby
class TodosController < ApplicationController
  private

  def todo_params
    params.require(:todo).permit(
      :title,
      :description,
      :done,
      items_attributes: [:id, :description, :status, :_destroy]
    )
  end
end
```

**Proteção CSRF:**
```erb
<!-- Em layouts/application.html.erb -->
<%= csrf_meta_tags %>

<!-- Em JavaScript -->
$.ajaxSetup({
  beforeSend: function(xhr) {
    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
  }
});
```

**Validação de arquivos:**
```ruby
class ImportJob < ApplicationJob
  def perform(file_path)
    # Validação do arquivo
    unless File.exist?(file_path)
      import_channel('Arquivo não encontrado', 'error')
      return
    end

    unless File.extname(file_path) == '.csv'
      import_channel('Formato de arquivo inválido', 'error')
      return
    end

    # Validação de tamanho
    if File.size(file_path) > 10.megabytes
      import_channel('Arquivo muito grande (máximo 10MB)', 'error')
      return
    end

    # Processamento...
  end
end
```

### Internacionalização (i18n)

**Configuração de locales:**
```yaml
# config/locales/pt-BR.yml
pt-BR:
  todos:
    index:
      title: "Lista de Tarefas"
      new_todo: "Nova Tarefa"
    form:
      title_placeholder: "Digite o título da tarefa"
    messages:
      created: "Tarefa criada com sucesso"
      updated: "Tarefa atualizada com sucesso"
      deleted: "Tarefa removida com sucesso"
```

**Uso nos controllers:**
```ruby
class TodosController < ApplicationController
  def create
    if @todo.save
      redirect_to @todo, notice: t('todos.messages.created')
    else
      render :new
    end
  end
end
```

**Uso no JavaScript:**
```javascript
// Adicionar translations no layout
window.I18n = {
  confirm_delete: "<%= t('common.confirm_delete') %>",
  success: "<%= t('common.success') %>"
};

// Uso no JS
App.Todo.destroy = (element) => {
  Alert.confirm(window.I18n.confirm_delete).then((result) => {
    // ... lógica de exclusão
  });
};
```

## Dicas de Contribuição e Boas Práticas

### Diretrizes de Desenvolvimento

1. **Frontend JavaScript:**
   - Use sempre o padrão de namespaces (`App.Module.method`)
   - Mantenha funções pequenas e focadas em uma responsabilidade
   - Implemente tratamento de erro padronizado para AJAX

2. **Formulários Aninhados:**
   - Use Cocoon para formulários dinâmicos como implementado em Todo-Items
   - Valide tanto no frontend quanto no backend
   - Mantenha IDs únicos para elementos dinâmicos

3. **Decorators vs Models:**
   - Decorators: lógica de apresentação (formatação, botões, badges)
   - Models: lógica de negócio (validações, cálculos, relacionamentos)
   - Services: lógica complexa que envolve múltiplos modelos

4. **Comunicação em Tempo Real:**
   - Use ActionCable channels existentes (ImportChannel, DeleteAllChannel)
   - Implemente feedback visual imediato
   - Mantenha mensagens padronizadas e traduzidas

5. **DataTables:**
   - Configure paginação server-side para grandes datasets
   - Use eager loading para evitar N+1 queries
   - Implemente busca eficiente com índices GIN

### Checklist para Pull Requests

**Antes de submeter:**
- [ ] Testes automatizados escritos e passando
- [ ] Código segue padrões de estilo (Rubocop)
- [ ] Migrações são reversíveis
- [ ] JavaScript usa namespaces apropriados
- [ ] Strings são internacionalizadas (i18n)
- [ ] Performance considerada (índices, eager loading)
- [ ] Tratamento de erros implementado
- [ ] Documentação atualizada se necessário

**Testes mínimos:**
- [ ] Model specs (validações, associações, scopes)
- [ ] Controller specs (ações principais)
- [ ] JavaScript specs (funcionalidades críticas)
- [ ] Integration specs (fluxos completos)

### Estrutura de Commits

Use conventional commits:
```bash
feat: adicionar filtro por categoria nos todos
fix: corrigir bug na paginação do datatable
docs: atualizar README com instruções de deploy
refactor: melhorar performance das queries de busca
test: adicionar testes para TodoDecorator
```

### Monitoramento e Métricas

**Para produção, considere:**
- APM tools (New Relic, Skylight)
- Error tracking (Sentry, Bugsnag)
- Performance monitoring
- Database query analysis

**Métricas importantes:**
- Tempo de resposta das páginas
- Taxa de erro de jobs Sidekiq
- Tempo de queries do banco
- Uso de memória Redis

### Troubleshooting Comum

**Problemas frequentes e soluções:**

1. **DataTable não carrega:**
   ```javascript
   // Verificar se o AJAX endpoint está correto
   console.log($('#todos').data('source'));

   // Verificar resposta do servidor
   $.get('/todos.json').then(console.log);
   ```

2. **Jobs Sidekiq não executam:**
   ```bash
   # Verificar se Redis está rodando
   redis-cli ping

   # Verificar filas do Sidekiq
   bundle exec sidekiq -e development -v
   ```

3. **ActionCable não conecta:**
   ```javascript
   // Verificar conexão WebSocket
   App.cable.connection.monitor.ping();

   // Debug no console do navegador
   App.cable.subscriptions.subscriptions.forEach(sub => console.log(sub));
   ```

4. **Performance lenta:**
   ```bash
   # Analisar queries lentas
   tail -f log/development.log | grep "Duration:"

   # Verificar índices não utilizados
   rails db console
   > ActiveRecord::Base.connection.execute("SELECT * FROM pg_stat_user_indexes WHERE idx_scan = 0")
   ```

### Recursos Adicionais

**Documentação útil:**
- [Rails Guides](https://guides.rubyonrails.org/)
- [DataTables Documentation](https://datatables.net/)
- [Sidekiq Wiki](https://github.com/mperham/sidekiq/wiki)
- [ActionCable Overview](https://guides.rubyonrails.org/action_cable_overview.html)
- [Draper Gem](https://github.com/drapergem/draper)

**Ferramentas de desenvolvimento:**
- `rails console` - Console interativo
- `rails dbconsole` - Console do banco
- `bundle exec sidekiq` - Interface web do Sidekiq
- `rails routes` - Visualizar rotas
- `rails stats` - Estatísticas do código
