# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReadCsv, type: :concern do
  let(:file_path) { Rails.root.join('tmp/test_read_csv.csv').to_path }

  before do
    # Criar arquivo CSV de teste
    CSV.open(file_path, 'w', col_sep: ';') do |csv|
      csv << ExportCsv::HEADERS
      csv << [1, 'Todo 1', 'Description 1', 'false', 0, '28/10/2025', '28/10/2025']
      csv << [2, 'Todo 2', 'Description 2', 'true', 2, '27/10/2025', '28/10/2025']
      csv << [3, 'Todo 3', 'Description 3', 'false', 1, '26/10/2025', '28/10/2025']
    end
  end

  after do
    File.delete(file_path) if File.exist?(file_path)
  end

  describe '.read_csv' do
    context 'with new todos' do
      it 'returns an array of Todo objects' do
        list = Todo.read_csv(file_path)

        expect(list).to all(be_a(Todo))
        expect(list.size).to eq(3)
      end

      it 'creates todos with correct attributes' do
        list = Todo.read_csv(file_path)

        first_todo = list.first
        expect(first_todo.title).to eq('Todo 1')
        expect(first_todo.description).to eq('Description 1')
        expect(first_todo.done).to be(false)
      end

      it 'does not include id in the new todos' do
        list = Todo.read_csv(file_path)

        list.each do |todo|
          expect(todo.id).to be_nil
        end
      end

      it 'does not include items_count in the attributes' do
        list = Todo.read_csv(file_path)

        list.each do |todo|
          expect(todo.attributes).not_to have_key('items_count')
        end
      end
    end

    context 'with existing todos' do
      before do
        create(:todo, title: 'Todo 1', description: 'Description 1', done: false)
      end

      it 'skips existing todos' do
        list = Todo.read_csv(file_path)

        # Should only include 2 new todos (Todo 2 and Todo 3)
        expect(list.size).to eq(2)
      end

      it 'does not include duplicate todos' do
        list = Todo.read_csv(file_path)

        titles = list.map(&:title)
        expect(titles).not_to include('Todo 1')
        expect(titles).to include('Todo 2', 'Todo 3')
      end
    end

    context 'with all existing todos' do
      before do
        create(:todo, title: 'Todo 1', description: 'Description 1', done: false)
        create(:todo, title: 'Todo 2', description: 'Description 2', done: true)
        create(:todo, title: 'Todo 3', description: 'Description 3', done: false)
      end

      it 'returns an empty array' do
        list = Todo.read_csv(file_path)

        expect(list).to be_empty
      end
    end

    context 'with empty CSV' do
      let(:empty_file_path) { Rails.root.join('tmp/empty_test.csv').to_path }

      before do
        CSV.open(empty_file_path, 'w', col_sep: ';') do |csv|
          csv << ExportCsv::HEADERS
        end
      end

      after do
        File.delete(empty_file_path) if File.exist?(empty_file_path)
      end

      it 'returns an empty array' do
        list = Todo.read_csv(empty_file_path)

        expect(list).to be_empty
      end
    end
  end

  describe '.csv_valid?' do
    context 'with a valid CSV file' do
      it 'returns true' do
        expect(Todo.csv_valid?(file_path)).to be true
      end

      it 'does not broadcast error message' do
        allow(ActionCable.server).to receive(:broadcast)

        Todo.csv_valid?(file_path)

        expect(ActionCable.server).not_to have_received(:broadcast)
      end
    end

    context 'with non-existent file' do
      let(:non_existent_file) { '/tmp/non_existent.csv' }

      it 'returns false' do
        expect(Todo.csv_valid?(non_existent_file)).to be false
      end

      it 'broadcasts error message' do
        allow(ActionCable.server).to receive(:broadcast)

        Todo.csv_valid?(non_existent_file)

        expect(ActionCable.server).to have_received(:broadcast).with(
          'import_channel',
          hash_including(message: /Arquivo inválido/, type: 'error')
        )
      end
    end

    context 'with wrong file extension' do
      let(:txt_file) { Rails.root.join('tmp/test.txt').to_path }

      before do
        File.write(txt_file, 'some content')
      end

      after do
        File.delete(txt_file) if File.exist?(txt_file)
      end

      it 'returns false' do
        expect(Todo.csv_valid?(txt_file)).to be false
      end

      it 'broadcasts error message' do
        allow(ActionCable.server).to receive(:broadcast)

        Todo.csv_valid?(txt_file)

        expect(ActionCable.server).to have_received(:broadcast).with(
          'import_channel',
          hash_including(message: /Arquivo inválido/, type: 'error')
        )
      end
    end

    context 'with invalid CSV format (wrong headers)' do
      let(:invalid_file) { Rails.root.join('tmp/invalid_headers.csv').to_path }

      before do
        CSV.open(invalid_file, 'w', col_sep: ';') do |csv|
          csv << %w[wrong headers here]
          csv << %w[some data values]
        end
      end

      after do
        File.delete(invalid_file) if File.exist?(invalid_file)
      end

      it 'returns false' do
        expect(Todo.csv_valid?(invalid_file)).to be false
      end

      it 'broadcasts error message' do
        allow(ActionCable.server).to receive(:broadcast)

        Todo.csv_valid?(invalid_file)

        expect(ActionCable.server).to have_received(:broadcast).with(
          'import_channel',
          hash_including(message: /Arquivo inválido/, type: 'error')
        )
      end
    end

    context 'with wrong column separator' do
      let(:comma_file) { Rails.root.join('tmp/comma_separated.csv').to_path }

      before do
        CSV.open(comma_file, 'w', col_sep: ',') do |csv|
          csv << ExportCsv::HEADERS
          csv << [1, 'Todo', 'Desc', 'false', 0, '28/10/2025', '28/10/2025']
        end
      end

      after do
        File.delete(comma_file) if File.exist?(comma_file)
      end

      it 'returns false' do
        expect(Todo.csv_valid?(comma_file)).to be false
      end
    end
  end

  describe '.file_valid?' do
    it 'returns true for existing CSV file' do
      expect(Todo.send(:file_valid?, file_path)).to be true
    end

    it 'returns false for non-existent file' do
      expect(Todo.send(:file_valid?, '/tmp/non_existent.csv')).to be false
    end

    it 'returns false for wrong extension' do
      txt_file = Rails.root.join('tmp/test.txt').to_path
      File.write(txt_file, 'content')

      expect(Todo.send(:file_valid?, txt_file)).to be false

      File.delete(txt_file)
    end
  end

  describe '.format_valid?' do
    it 'returns true for correct header format' do
      expect(Todo.send(:format_valid?, file_path)).to be true
    end

    it 'returns false for incorrect headers' do
      invalid_file = Rails.root.join('tmp/invalid_format.csv').to_path
      CSV.open(invalid_file, 'w', col_sep: ';') do |csv|
        csv << %w[wrong headers]
      end

      expect(Todo.send(:format_valid?, invalid_file)).to be false

      File.delete(invalid_file)
    end

    it 'checks for exact header match' do
      partial_file = Rails.root.join('tmp/partial_headers.csv').to_path
      CSV.open(partial_file, 'w', col_sep: ';') do |csv|
        csv << %w[id title description] # Missing some headers
      end

      expect(Todo.send(:format_valid?, partial_file)).to be false

      File.delete(partial_file)
    end
  end
end
