# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :todo, inverse_of: :items

  validates :description, presence: true
end
