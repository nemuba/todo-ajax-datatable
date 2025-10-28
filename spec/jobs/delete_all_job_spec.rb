# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeleteAllJob, type: :job do
  describe '#perform' do
    let!(:todo1) { create(:todo, title: 'Todo 1') }
    let!(:todo2) { create(:todo, title: 'Todo 2') }
    let!(:todo3) { create(:todo, title: 'Todo 3') }
    let(:ids_to_delete) { [todo1.id, todo2.id] }

    context 'with valid ids' do
      it 'deletes the specified todos' do
        expect do
          described_class.perform_now(ids_to_delete)
        end.to change(Todo, :count).by(-2)
      end

      it 'deletes only the specified todos' do
        described_class.perform_now(ids_to_delete)

        expect(Todo.exists?(todo1.id)).to be false
        expect(Todo.exists?(todo2.id)).to be false
        expect(Todo.exists?(todo3.id)).to be true
      end

      it 'broadcasts success message to delete_all channel' do
        expect(ActionCable.server).to receive(:broadcast).with(
          'delete_all_channel',
          hash_including(message: /Exclusão em lote finalizada com sucesso/)
        )

        described_class.perform_now(ids_to_delete)
      end

      it 'uses a database transaction' do
        # Verificar se o método transaction é chamado pelo menos uma vez
        expect(Todo).to receive(:transaction).at_least(:once).and_call_original

        described_class.perform_now(ids_to_delete)
      end
    end

    context 'with non-existent ids' do
      let(:invalid_ids) { [99_999, 88_888] }

      it 'does not raise an error' do
        expect do
          described_class.perform_now(invalid_ids)
        end.not_to raise_error
      end

      it 'does not delete any todos' do
        expect do
          described_class.perform_now(invalid_ids)
        end.not_to change(Todo, :count)
      end

      it 'broadcasts success message anyway' do
        expect(ActionCable.server).to receive(:broadcast).with(
          'delete_all_channel',
          hash_including(message: /Exclusão em lote finalizada com sucesso/)
        )

        described_class.perform_now(invalid_ids)
      end
    end

    context 'when an error occurs during deletion' do
      before do
        allow(Todo).to receive(:where).and_raise(StandardError.new('Database error'))
      end

      it 'broadcasts error message' do
        expect(ActionCable.server).to receive(:broadcast).with(
          'delete_all_channel',
          hash_including(message: /Database error/, type: 'error')
        )

        described_class.perform_now(ids_to_delete)
      end

      it 'does not delete any todos due to transaction rollback' do
        original_count = Todo.count

        described_class.perform_now(ids_to_delete)

        expect(Todo.count).to eq(original_count)
      end
    end

    context 'with empty ids array' do
      let(:empty_ids) { [] }

      it 'does not delete any todos' do
        expect do
          described_class.perform_now(empty_ids)
        end.not_to change(Todo, :count)
      end

      it 'broadcasts success message' do
        expect(ActionCable.server).to receive(:broadcast).with(
          'delete_all_channel',
          hash_including(message: /Exclusão em lote finalizada com sucesso/)
        )

        described_class.perform_now(empty_ids)
      end
    end
  end

  describe 'job queue' do
    it 'is enqueued in the default queue' do
      expect(described_class.new.queue_name).to eq('default')
    end
  end
end
