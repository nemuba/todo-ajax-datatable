# frozen_string_literal: true

class Todo < ApplicationRecord
  extend ExportCsv
  extend ReadCsv

  validates :title, :description, presence: true

  has_many :items, dependent: :destroy, inverse_of: :todo

  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true
end
