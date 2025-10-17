# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Todos', type: :request do
  describe 'GET /todos' do
    it 'returns http success' do
      get todos_path
      expect(response).to have_http_status(:success)
    end

    it 'renders the index template' do
      get todos_path
      expect(response).to render_template(:index)
    end

    context 'as JSON' do
      it 'returns json data' do
        create_list(:todo, 3)
        get todos_path, headers: { 'Accept' => 'application/json' }

        expect(response).to have_http_status(:success)
        expect(response.content_type).to include('application/json')
      end
    end
  end

  describe 'POST /todos' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          todo: {
            title: 'New Todo',
            description: 'Todo Description',
            done: false
          }
        }
      end

      it 'creates a new todo' do
        expect {
          post todos_path, params: valid_params, xhr: true
        }.to change(Todo, :count).by(1)
      end

      it 'returns success response' do
        post todos_path, params: valid_params, xhr: true
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          todo: {
            title: '',
            description: '',
            done: false
          }
        }
      end

      it 'does not create a new todo' do
        expect {
          post todos_path, params: invalid_params, xhr: true
        }.not_to change(Todo, :count)
      end
    end
  end

  describe 'PATCH /todos/:id' do
    let(:todo) { create(:todo) }

    context 'with valid parameters' do
      let(:new_attributes) do
        {
          todo: {
            title: 'Updated Title',
            description: 'Updated Description'
          }
        }
      end

      it 'updates the todo' do
        patch todo_path(todo), params: new_attributes, xhr: true
        todo.reload

        expect(todo.title).to eq('Updated Title')
        expect(todo.description).to eq('Updated Description')
      end

      it 'returns success response' do
        patch todo_path(todo), params: new_attributes, xhr: true
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'DELETE /todos/:id' do
    let!(:todo) { create(:todo) }

    it 'destroys the todo' do
      expect {
        delete todo_path(todo), xhr: true
      }.to change(Todo, :count).by(-1)
    end

    it 'returns success response' do
      delete todo_path(todo), xhr: true
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /todos/:id/clone' do
    let(:todo) { create(:todo, :with_items) }

    it 'returns success response' do
      get clone_todo_path(todo), xhr: true
      expect(response).to have_http_status(:success)
    end

    it 'prepares todo and items for duplication' do
      get clone_todo_path(todo), xhr: true

      expect(assigns(:todo)).to be_a_new(Todo)
      expect(assigns(:todo).title).to eq(todo.title)
      expect(assigns(:items)).to be_present
    end
  end
end
