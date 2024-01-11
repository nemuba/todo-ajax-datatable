# frozen_string_literal: true

require 'csv'
require 'active_support/concern'

module ExportCsv
  extend ActiveSupport::Concern

  HEADERS = %w[id title description done items created_at updated_at].freeze

  def to_csv
    CSV.generate(headers: true, col_sep: ';') do |csv|
      csv << HEADERS
      includes(:items).order(:id).each do |todo|
        csv << [
          todo.id, todo.title, todo.description,
          todo.done, todo.items.size,
          todo.decorate.created_at, todo.decorate.updated_at
        ]
      end
    end
  end
end
