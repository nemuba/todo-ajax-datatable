# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExportCsv, type: :concern do
  let(:dummy_class) do
    Class.new do
      include ExportCsv

      def self.name
        'DummyClass'
      end
    end
  end

  describe '.to_csv' do
    let!(:todo1) { create(:todo, title: 'First Todo', description: 'Description 1', done: false) }
    let!(:todo2) { create(:todo, :completed, title: 'Second Todo', description: 'Description 2') }
    let!(:todo_with_items) { create(:todo, :with_items, title: 'Todo with items') }

    it 'generates a CSV with headers' do
      csv = Todo.to_csv

      expect(csv).to include('id;title;description;done;items_count;created_at;updated_at')
    end

    it 'includes all todos in the CSV' do
      csv = Todo.to_csv
      lines = csv.split("\n")

      # Header + 3 todos
      expect(lines.size).to eq(4)
    end

    it 'exports todo attributes correctly' do
      csv = Todo.to_csv

      expect(csv).to include(todo1.title)
      expect(csv).to include(todo1.description)
      expect(csv).to include('false') # done status
    end

    it 'exports completed todo correctly' do
      csv = Todo.to_csv

      expect(csv).to include(todo2.title)
      expect(csv).to include('true') # done status
    end

    it 'includes items count' do
      csv = Todo.to_csv

      # Todo with items should have count of 3
      lines = csv.split("\n")
      todo_with_items_line = lines.find { |line| line.include?(todo_with_items.title) }

      expect(todo_with_items_line).to include('3')
    end

    it 'formats dates in Brazilian format' do
      create(:todo, created_at: Time.zone.parse('2025-10-28'), updated_at: Time.zone.parse('2025-10-29'))
      csv = Todo.to_csv

      expect(csv).to include('28/10/2025')
      expect(csv).to include('29/10/2025')
    end

    it 'orders todos by id' do
      csv = Todo.to_csv
      lines = csv.split("\n")[1..-1] # Skip header

      ids = lines.map { |line| line.split(';').first.to_i }

      expect(ids).to eq(ids.sort)
    end

    it 'uses semicolon as column separator' do
      csv = Todo.to_csv

      expect(csv).to include(';')
    end

    it 'handles todos with no items' do
      csv = Todo.to_csv
      todo1_line = csv.split("\n").find { |line| line.include?(todo1.title) }

      expect(todo1_line).to include('0') # items_count
    end
  end

  describe '.format_date' do
    it 'formats date correctly' do
      date = Time.zone.parse('2025-10-28 15:30:00')
      formatted = Todo.send(:format_date, date)

      expect(formatted).to eq('28/10/2025')
    end

    it 'handles nil dates' do
      formatted = Todo.send(:format_date, nil)

      expect(formatted).to be_nil
    end
  end

  describe 'HEADERS constant' do
    it 'includes all expected headers' do
      expect(ExportCsv::HEADERS).to eq(%w[id title description done items_count created_at updated_at])
    end
  end
end
