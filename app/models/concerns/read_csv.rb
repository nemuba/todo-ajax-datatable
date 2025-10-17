# frozen_string_literal: true

require 'csv'
require 'active_support/concern'

module ReadCsv
  extend ActiveSupport::Concern

  def read_csv(file)
    list = []

    CSV.foreach(file, headers: true, col_sep: ';') do |row|
      query = row.to_h.slice('title', 'description', 'done')
      next if Todo.exists?(query)

      list << Todo.new(row.to_h.except('id', 'items_count'))
    end

    list
  end

  def csv_valid?(file)
    return true if file_valid?(file) && format_valid?(file)

    ActionCable.server.broadcast('import_channel', message: 'Arquivo inválido, verifique formato(.csv) e os campos',
                                                   type: 'error')

    false
  end

  private

  def file_valid?(file)
    File.exist?(file) && File.extname(file) == '.csv'
  end

  def format_valid?(file)
    CSV.read(file, col_sep: ';', headers: true).headers == ExportCsv::HEADERS
  end
end
