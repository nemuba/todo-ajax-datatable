# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportJob, type: :job do
  let(:file_path) { Rails.root.join('tmp/test_import.csv').to_path }

  before do
    # Criar arquivo de teste com formato correto (com semicolon)
    CSV.open(file_path, 'w', col_sep: ';') do |csv|
      csv << ExportCsv::HEADERS
      csv << [nil, 'Test Todo 1', 'Description 1', 'false', 0, '28/10/2025', '28/10/2025']
      csv << [nil, 'Test Todo 2', 'Description 2', 'true', 0, '28/10/2025', '28/10/2025']
    end
  end

  after do
    # Limpar arquivo após teste
    File.delete(file_path) if File.exist?(file_path)
  end

  describe '#perform' do
    context 'with a valid CSV file' do
      it 'imports todos from the CSV' do
        expect do
          described_class.perform_now(file_path)
        end.to change(Todo, :count).by(2)
      end

      it 'imports todos with correct attributes' do
        described_class.perform_now(file_path)

        todo1 = Todo.find_by(title: 'Test Todo 1')
        expect(todo1.description).to eq('Description 1')
        expect(todo1.done).to eq(false)

        todo2 = Todo.find_by(title: 'Test Todo 2')
        expect(todo2.description).to eq('Description 2')
        expect(todo2.done).to eq(true)
      end

      it 'deletes the file after import' do
        described_class.perform_now(file_path)

        expect(File.exist?(file_path)).to be false
      end

      it 'broadcasts success message to import channel' do
        expect(ActionCable.server).to receive(:broadcast).with(
          'import_channel',
          hash_including(message: /Importação finalizada/)
        )

        described_class.perform_now(file_path)
      end
    end

    context 'with an invalid CSV file' do
      let(:invalid_file_path) { Rails.root.join('tmp/invalid_import.csv').to_path }

      before do
        CSV.open(invalid_file_path, 'w', col_sep: ';') do |csv|
          csv << %w[wrong columns here]
          csv << ['data', 'that', 'doesnt match']
        end
      end

      after do
        File.delete(invalid_file_path) if File.exist?(invalid_file_path)
      end

      it 'does not import todos' do
        expect do
          described_class.perform_now(invalid_file_path)
        end.not_to change(Todo, :count)
      end

      it 'deletes the file even on error' do
        described_class.perform_now(invalid_file_path)

        expect(File.exist?(invalid_file_path)).to be false
      end
    end

    context 'with empty CSV (no new records)' do
      let(:empty_file_path) { Rails.root.join('tmp/empty_import.csv').to_path }

      before do
        CSV.open(empty_file_path, 'w', col_sep: ';') do |csv|
          csv << ExportCsv::HEADERS
        end
      end

      after do
        File.delete(empty_file_path) if File.exist?(empty_file_path)
      end

      it 'does not create new todos' do
        expect do
          described_class.perform_now(empty_file_path)
        end.not_to change(Todo, :count)
      end

      it 'broadcasts warning message' do
        expect(ActionCable.server).to receive(:broadcast).with(
          'import_channel',
          hash_including(message: /Nenhum registro novo/, type: 'warning')
        )

        described_class.perform_now(empty_file_path)
      end
    end

    context 'when validation errors occur' do
      before do
        # Criar arquivo com dados inválidos (title vazio viola validação)
        CSV.open(file_path, 'w', col_sep: ';') do |csv|
          csv << ExportCsv::HEADERS
          csv << [nil, '', 'Description only', 'false', 0, '28/10/2025', '28/10/2025'] # Title vazio
        end
      end

      it 'handles validation errors gracefully' do
        # Não deve criar o todo inválido
        expect do
          described_class.perform_now(file_path)
        end.not_to change(Todo, :count)
      end

      it 'still deletes the file' do
        described_class.perform_now(file_path)

        expect(File.exist?(file_path)).to be false
      end
    end
  end

  describe 'job queue' do
    it 'is enqueued in the default queue' do
      expect(described_class.new.queue_name).to eq('default')
    end
  end
end
