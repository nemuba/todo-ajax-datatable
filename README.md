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

A aplicação utiliza RSpec para testes. Para executar a suite de testes:
