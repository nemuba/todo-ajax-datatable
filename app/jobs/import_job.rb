# frozen_string_literal: true

class ImportJob < ApplicationJob
  queue_as :default

  def perform(file)
    return unless Todo.csv_valid?(file)

    list = Todo.read_csv(file)

    if list.any?
      Todo.transaction do
        Todo.import(list)
      rescue StandardError => e
        import_channel("Erro ao importar: #{e.message}", 'error')
      end

      import_channel("Importação finalizada, #{list.size} novos registros")
    else
      import_channel('Nenhum registro novo para importar', 'warning')
    end
  ensure
    File.delete(file) if File.exist?(file)
  end
end
