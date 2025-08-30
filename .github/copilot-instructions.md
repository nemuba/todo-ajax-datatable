# Instruções para trabalho com o TODO AJAX DataTable

## Arquitetura Geral

Este é um aplicativo Ruby on Rails (5.2.3) que gerencia tarefas (Todos) com uma arquitetura focada em:

- **Models**: Todo e Item com relacionamento pai-filho (1:N)
- **Controllers**: Principalmente TodosController com funcionalidades CRUD
- **DataTables**: Renderização de tabelas interativas via ajax-datatables-rails
- **Decorators**: Usando Draper para decoração de views
- **Jobs**: Processamento assíncrono via Sidekiq
- **Channels**: Comunicação em tempo real via ActionCable

## Padrões Importantes

### Convenções de Código

- Modelos seguem as convenções de Rails com validações e associações explícitas
- Decorators separam a lógica de apresentação dos modelos
- JavaScript organizado usando namespaces (ex: App.Todo, App.Modal)

### Padrão de DataTables

A aplicação usa DataTables para apresentação tabular, definido em:
- `app/datatables/todo_datatable.rb` - Classe Ruby para configuração do DataTable
- `app/assets/javascripts/datatables.js` - Configuração do lado do cliente

Exemplo de uso:
```ruby
# Em controllers
format.json { render json: TodoDatatable.new(params, view_context: view_context) }

# Em views
<%= datatable_ajax(id: 'todos', url: todos_path(format: :json)) do %>
  <tfoot>
    <tr>
      <th></th>
      <th>#</th>
      <th>Título</th>
      <!-- ... -->
    </tr>
  </tfoot>
<% end %>
```

### Processamento Assíncrono

A aplicação usa Sidekiq para operações pesadas como:
- Importação de arquivos CSV via `ImportJob`
- Exclusão em lote via `DeleteAllJob`

Os jobs se comunicam com o frontend usando ActionCable:
```ruby
# Exemplo em jobs
def import_channel(message, type = 'success')
  ActionCable.server.broadcast('import_channel', { message: message, type: type })
end
```

### Exportação de Documentos

A aplicação exporta dados em vários formatos via módulo `ExportDocument`:
```ruby
format.csv { send_data Todo.to_csv, filename: filename('csv') }
format.pdf { render_data(:pdf, { todos: Todo.includes(:items).all }) }
format.docx { render_data(:docx, { todos: Todo.includes(:items).all }) }
format.xlsx { render_data(:xlsx, { todos: Todo.includes(:items).all }) }
```

## Fluxos de Desenvolvimento

### Configurando o Ambiente

```bash
# Dependências
bundle install
yarn install

# Banco de dados
rails db:create
rails db:migrate

# Serviços necessários
redis-server
bundle exec sidekiq
rails s
```

### Testes

O projeto usa RSpec para testes. Para criar novos testes, siga o padrão:
```ruby
# spec/models/todo_spec.rb
require 'rails_helper'

RSpec.describe Todo, type: :model do
  # ...
end
```

## Dicas de Contribuição

- Ao adicionar novas funcionalidades no frontend, use o padrão de namespaces em JavaScript
- Para formulários aninhados, use Cocoon como implementado em Todo-Items
- Mantenha os decoradores para lógica de apresentação e serviços para lógica de negócios
- Para integrações em tempo real, use os canais ActionCable existentes
