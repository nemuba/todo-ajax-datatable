# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Todo, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end

  describe 'associations' do
    it { should have_many(:items).dependent(:destroy) }
  end

  describe 'nested attributes' do
    it { should accept_nested_attributes_for(:items).allow_destroy(true) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      todo = build(:todo)
      expect(todo).to be_valid
    end

    it 'creates a todo with items using trait' do
      todo = create(:todo, :with_items)
      expect(todo.items.count).to eq(3)
    end
  end

  describe '#done' do
    context 'when todo is completed' do
      it 'returns true' do
        todo = create(:todo, :completed)
        expect(todo.done).to be true
      end
    end

    context 'when todo is not completed' do
      it 'returns false' do
        todo = create(:todo)
        expect(todo.done).to be false
      end
    end
  end
end
