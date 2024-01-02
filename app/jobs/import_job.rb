class ImportJob < ApplicationJob
  queue_as :default

  def perform(file)
    CSV.foreach(file, headers: true, col_sep: ';') do |row|
      Todo.find_or_create_by!({
        title: row['Titulo'],
        description: row['Descrição'],
        done: row['Feito'] == 'Sim'
      })
    end

    ActionCable.server.broadcast('import_channel', message: 'Importação concluída')
  ensure
    File.delete(file) if File.exist?(file)
  end
end
