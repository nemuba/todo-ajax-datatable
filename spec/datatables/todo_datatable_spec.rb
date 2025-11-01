# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TodoDatatable, type: :datatable do
  let(:view) { instance_double(ActionView::Base, params: {}) }
  let(:params) { {} }
  let(:datatable) { described_class.new(params, view_context: view) }

  describe '#view_columns' do
    it 'returns the correct column configuration' do
      columns = datatable.view_columns

      expect(columns).to include(
        id: { source: 'Todo.id', cond: :eq },
        title: { source: 'Todo.title', cond: :like },
        description: { source: 'Todo.description', cond: :like },
        done: { source: 'Todo.done', cond: :like },
        created_at: { source: 'Todo.created_at', cond: :like },
        updated_at: { source: 'Todo.updated_at', cond: :like }
      )
    end
  end

  describe '#data' do
    let(:todo_with_items) { create(:todo, :with_items, title: 'Todo with items') }

    before do
      create(:todo, title: 'First Todo', done: false)
      create(:todo, :completed, title: 'Second Todo')
      todo_with_items
      # Mock the datatable to return our todos
      allow(datatable).to receive(:records).and_return(Todo.includes(:items).all)
    end

    it 'returns data for all todos' do
      data = datatable.data

      expect(data.size).to eq(3)
    end

    it 'includes all required fields' do
      data = datatable.data
      first_record = data.first

      expect(first_record).to include(
        :id,
        :title,
        :description,
        :done,
        :items,
        :created_at,
        :updated_at,
        :actions,
        :DT_RowId
      )
    end

    it 'returns the correct number of items' do
      data = datatable.data
      todo_with_items_data = data.find { |d| d[:id] == todo_with_items.id }

      expect(todo_with_items_data[:items]).to eq(3)
    end

    it 'uses decorator for formatted fields' do
      data = datatable.data
      first_record = data.first

      # Verificar se os campos decorados estão presentes
      expect(first_record[:done]).to be_present
      expect(first_record[:created_at]).to be_present
      expect(first_record[:updated_at]).to be_present
      expect(first_record[:actions]).to be_present
    end

    it 'includes DT_RowId for DataTables' do
      data = datatable.data

      data.each do |record|
        expect(record[:DT_RowId]).to eq(record[:id])
      end
    end
  end

  describe '#get_raw_records' do
    before do
      # Ensure there are todos in the database
      create(:todo)
      create(:todo, :with_items)
    end

    it 'returns all todos' do
      records = datatable.send(:get_raw_records)

      expect(records.size).to eq(2)
    end

    it 'includes items association' do
      records = datatable.send(:get_raw_records).to_a

      # Verifica se não há N+1 query problem
      # Com includes(:items), deveria fazer apenas 1 query para items
      expect do
        records.each do |record|
          record.items.size
        end
      end.not_to exceed_query_limit(1)
    end
  end
end
