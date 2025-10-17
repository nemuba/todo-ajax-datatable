# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TodosController, type: :controller do
  describe 'GET #index' do
    context 'as HTML' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end
    end

    context 'as JSON' do
      it 'returns json data for datatables' do
        create_list(:todo, 3)
        get :index, format: :json
        expect(response).to be_successful
        expect(response.content_type).to include('application/json')
      end
    end
  end

  describe 'GET #show' do
    let(:todo) { create(:todo) }

    it 'returns a success response' do
      get :show, params: { id: todo.to_param }, format: :js, xhr: true
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, format: :js, xhr: true
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    let(:todo) { create(:todo) }

    it 'returns a success response' do
      get :edit, params: { id: todo.to_param }, format: :js, xhr: true
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_attributes) do
        {
          title: 'Test Todo',
          description: 'Test Description',
          done: false
        }
      end

      it 'creates a new Todo' do
        expect {
          post :create, params: { todo: valid_attributes }, format: :js, xhr: true
        }.to change(Todo, :count).by(1)
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) do
        {
          title: '',
          description: '',
          done: false
        }
      end

      it 'does not create a new Todo' do
        expect {
          post :create, params: { todo: invalid_attributes }, format: :js, xhr: true
        }.to change(Todo, :count).by(0)
      end
    end
  end

  describe 'PATCH #update' do
    let(:todo) { create(:todo) }

    context 'with valid params' do
      let(:new_attributes) do
        {
          title: 'Updated Title',
          description: 'Updated Description'
        }
      end

      it 'updates the requested todo' do
        patch :update, params: { id: todo.to_param, todo: new_attributes }, format: :js, xhr: true
        todo.reload
        expect(todo.title).to eq('Updated Title')
        expect(todo.description).to eq('Updated Description')
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) do
        {
          title: '',
          description: ''
        }
      end

      it 'does not update the todo' do
        original_title = todo.title
        patch :update, params: { id: todo.to_param, todo: invalid_attributes }, format: :js, xhr: true
        todo.reload
        expect(todo.title).to eq(original_title)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:todo) { create(:todo) }

    it 'destroys the requested todo' do
      expect {
        delete :destroy, params: { id: todo.to_param }, format: :js, xhr: true
      }.to change(Todo, :count).by(-1)
    end
  end

  describe 'GET #clone' do
    let(:todo) { create(:todo, :with_items) }

    it 'duplicates the todo and its items' do
      get :clone, params: { id: todo.to_param }, format: :js, xhr: true
      expect(response).to be_successful
      expect(assigns(:todo)).to be_a_new(Todo)
      expect(assigns(:todo).title).to eq(todo.title)
      expect(assigns(:items).count).to eq(todo.items.count)
    end
  end
end
