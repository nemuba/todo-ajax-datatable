# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TodoService, type: :service do
  describe '.import' do
    let(:tempfile) { instance_double(Tempfile, read: 'csv content') }
    let(:file_path) { Rails.root.join('tmp/import.csv').to_path }

    before do
      # Limpar arquivo se existir
      File.delete(file_path) if File.exist?(file_path)
    end

    after do
      # Limpar arquivo após teste
      File.delete(file_path) if File.exist?(file_path)
    end

    it 'writes the tempfile content to the file system' do
      allow(ImportJob).to receive(:perform_later)

      described_class.import(tempfile)

      expect(File.exist?(file_path)).to be true
      expect(File.read(file_path)).to eq('csv content')
    end

    it 'enqueues an ImportJob' do
      allow(ImportJob).to receive(:perform_later)

      described_class.import(tempfile)

      expect(ImportJob).to have_received(:perform_later).with(file_path)
    end

    it 'creates the file before enqueuing the job' do
      allow(ImportJob).to receive(:perform_later) do
        expect(File.exist?(file_path)).to be true
      end

      described_class.import(tempfile)
    end
  end

  describe '.file_path' do
    it 'returns the correct file path' do
      expected_path = Rails.root.join('tmp/import.csv').to_path

      expect(described_class.file_path).to eq(expected_path)
    end

    it 'returns a string' do
      expect(described_class.file_path).to be_a(String)
    end
  end
end
