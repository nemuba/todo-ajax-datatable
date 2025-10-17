# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:description) }
  end

  describe 'associations' do
    it { should belong_to(:todo) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      item = build(:item)
      expect(item).to be_valid
    end

    it 'creates a completed item using trait' do
      item = create(:item, :completed)
      expect(item.status).to be true
    end

    it 'creates an incomplete item using trait' do
      item = create(:item, :incomplete)
      expect(item.status).to be false
    end
  end

  describe '#status' do
    it 'can be true or false' do
      item_completed = create(:item, status: true)
      item_incomplete = create(:item, status: false)
      
      expect(item_completed.status).to be true
      expect(item_incomplete.status).to be false
    end
  end
end
