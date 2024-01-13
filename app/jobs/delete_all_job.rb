# frozen_string_literal: true

class DeleteAllJob < ApplicationJob
  queue_as :default

  def perform(ids)
    Todo.transaction do
      Todo.where(id: ids).destroy_all
    rescue StandardError => e
      delete_all_channel e.message, 'error'
    else
      delete_all_channel 'Exclusão em lote finalizada com sucesso!'
    end
  end
end
