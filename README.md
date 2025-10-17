# TODO APP

## Descrição

Este é um aplicativo de tarefas que permite adicionar, editar, excluir e marcar tarefas como concluídas. A aplicação utiliza AJAX e DataTables para oferecer uma experiência de usuário dinâmica e interativa. As tarefas podem conter múltiplos itens, que também podem ser gerenciados.

## Funcionalidades

- Criar, editar, clonar e excluir tarefas
- Adicionar múltiplos itens a uma tarefa
- Marcar tarefas como concluídas
- Visualização em tabela com suporte a paginação, ordenação e pesquisa
- Importação e exportação de dados via CSV
- Exportação para PDF, DOCX e XLSX
- Operações em tempo real com ActionCable
- Interface responsiva usando Bootstrap

## Tecnologias Utilizadas

- **Ruby**: 2.5.3
- **Rails**: 5.2.3
- **PostgreSQL**: Para armazenamento de dados
- **Bootstrap**: Framework CSS para interface responsiva
- **jQuery**: Para manipulação de DOM e AJAX
- **ActionCable**: Para funcionalidades em tempo real
- **Sidekiq**: Para processamento de jobs em segundo plano

### Gems Principais

- [Cocoon](https://github.com/nathanvda/cocoon): Para formulários aninhados
- [ajax-datatables-rails](https://github.com/jbox-web/ajax-datatables-rails): Para tabelas interativas com AJAX
- [jquery-datatables](https://github.com/mkhairi/jquery-datatables): Integração do jQuery DataTables com Rails
- [Draper](https://github.com/drapergem/draper): Para decoração de modelos
- [wicked_pdf](https://github.com/mileszs/wicked_pdf): Para geração de PDFs
- [font-awesome-sass](https://github.com/FortAwesome/font-awesome-sass): Para ícones

## Configuração

### Requisitos

- Ruby 2.5.3
- Rails 5.2.3
- PostgreSQL
- Redis (para Sidekiq)

### Instalação

1. Clone o repositório

   ```
   git clone https://github.com/seu-usuario/todo-ajax-datatable.git
   cd todo-ajax-datatable
   ```

2. Instale as dependências

   ```
   bundle install
   yarn install
   ```

3. Configure o banco de dados

   ```
   cp config/database.yml.example config/database.yml
   # Edite o arquivo para configurar suas credenciais do PostgreSQL
   ```

4. Crie e migre o banco de dados

   ```
   rails db:create
   rails db:migrate
   rails db:seed # opcional para dados de exemplo
   ```

5. Inicie os serviços

   ```
   # Em terminais separados:
   redis-server
   bundle exec sidekiq
   rails s
   ```

6. Acesse a aplicação em `http://localhost:3000`

## Uso

### Tarefas

- **Listar tarefas**: Visualize todas as suas tarefas na página inicial
- **Criar tarefa**: Clique em "Nova Tarefa" e preencha o formulário
- **Editar tarefa**: Clique no ícone de edição na linha da tarefa
- **Excluir tarefa**: Clique no ícone de exclusão na linha da tarefa
- **Clonar tarefa**: Clique no ícone de clonagem para duplicar uma tarefa

### Importação/Exportação

- **Importar tarefas**: Clique em "Importar" e selecione um arquivo CSV
- **Exportar tarefas**: Use os botões de exportação para CSV, PDF, XLSX ou DOCX

## Estrutura de Arquivos

A aplicação segue a estrutura padrão de projetos Rails, com algumas pastas adicionais:

- `app/datatables`: Classes para definição de DataTables
- `app/decorators`: Decoradores de modelo usando Draper
- `app/services`: Classes de serviço para lógica de negócios

## Testes

O projeto utiliza RSpec para testes automatizados, com suporte para:

- **RSpec Rails**: Framework de testes para Rails
- **FactoryBot**: Para criação de dados de teste
- **Shoulda Matchers**: Matchers para testes de validações e associações
- **DatabaseCleaner**: Para limpar o banco de dados entre testes
- **SimpleCov**: Para relatório de cobertura de código

### Executando os Testes

```bash
# Executar todos os testes
bundle exec rspec

# Executar testes específicos
bundle exec rspec spec/models
bundle exec rspec spec/controllers
bundle exec rspec spec/models/todo_spec.rb

# Executar com formatação detalhada
bundle exec rspec --format documentation

# Gerar relatório de cobertura (veja em coverage/index.html)
bundle exec rspec
```

### Estrutura de Testes

```
spec/
├── factories/          # Definições de factories para testes
│   ├── todos.rb
│   └── items.rb
├── models/            # Testes de modelos
│   ├── todo_spec.rb
│   └── item_spec.rb
├── controllers/       # Testes de controllers
│   └── todos_controller_spec.rb
├── support/           # Arquivos de suporte
│   ├── factory_bot.rb
│   └── simplecov.rb
├── rails_helper.rb    # Configuração principal do RSpec para Rails
└── spec_helper.rb     # Configuração geral do RSpec
```

### Escrevendo Testes

Os testes seguem as convenções do RSpec e utilizam FactoryBot para criação de dados:

```ruby
# Exemplo de teste de modelo
RSpec.describe Todo, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      todo = build(:todo)
      expect(todo).to be_valid
    end
  end
end

# Exemplo de teste de controller
RSpec.describe TodosController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end
end
```

## Contribuindo

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas alterações (`git commit -am 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Crie um novo Pull Request

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).
