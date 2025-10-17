# frozen_string_literal: true

require 'csv'
require 'active_support/concern'

module ExportCsv
  extend ActiveSupport::Concern

  HEADERS = %w[id title description done items_count created_at updated_at].freeze

  class_methods do
    def to_csv
      CSV.generate(headers: true, col_sep: ';') do |csv|
        csv << HEADERS
        includes(:items).order(:id).each do |todo|
          csv << [
            todo.id,
            todo.title,
            todo.description,
            todo.done?,
            todo.items.size,
            format_date(todo.created_at),
            format_date(todo.updated_at)
          ]
        end
      end
    end

    private

    def format_date(date)
      date&.strftime('%d/%m/%Y')
    end
  end
end
