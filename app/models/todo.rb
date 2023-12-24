# frozen_string_literal: true

require 'csv'
class Todo < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true

  has_many :items, dependent: :destroy, inverse_of: :todo

  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true

  HEADERS = ['id', 'Titulo', 'Descrição', 'Feito', 'Items', 'Criado em', 'Atualizado em'].freeze

  def self.to_csv
    CSV.generate(headers: true, col_sep: ';') do |csv|
      csv << HEADERS
      includes(:items).order(:id).each do |todo|
        csv << [
          todo.id, todo.title, todo.description,
          todo.done ? 'Sim' : 'Não', todo.items.size,
          todo.decorate.created_at, todo.decorate.updated_at
        ]
      end
    end
  end
end
