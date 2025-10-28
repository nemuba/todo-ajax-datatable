# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TodoDecorator, type: :decorator do
  let(:todo) { create(:todo).decorate }
  let(:completed_todo) { create(:todo, :completed).decorate }

  describe '#done' do
    context 'when todo is not completed' do
      it 'returns a danger badge with times icon' do
        result = todo.done

        expect(result).to include('badge-danger')
        expect(result).to include('fa-times')
      end
    end

    context 'when todo is completed' do
      it 'returns a success badge with check icon' do
        result = completed_todo.done

        expect(result).to include('badge-success')
        expect(result).to include('fa-check')
      end
    end

    it 'includes badge-pill class' do
      result = todo.done

      expect(result).to include('badge-pill')
    end
  end

  describe '#created_at' do
    it 'formats the date in Brazilian format' do
      todo = create(:todo, created_at: Time.zone.parse('2025-10-28 10:30:00')).decorate

      expect(todo.created_at).to eq('28/10/2025')
    end

    it 'returns a string' do
      expect(todo.created_at).to be_a(String)
    end
  end

  describe '#updated_at' do
    it 'formats the date in Brazilian format' do
      todo = create(:todo, updated_at: Time.zone.parse('2025-10-28 15:45:00')).decorate

      expect(todo.updated_at).to eq('28/10/2025')
    end

    it 'returns a string' do
      expect(todo.updated_at).to be_a(String)
    end
  end

  describe '#dt_actions' do
    let(:helper) { todo.h }

    before do
      allow(helper).to receive(:todo_path).and_return('/todos/1')
      allow(helper).to receive(:edit_todo_path).and_return('/todos/1/edit')
      allow(helper).to receive(:clone_todo_path).and_return('/todos/1/clone')
    end

    it 'returns action buttons wrapped in btn-group' do
      result = todo.dt_actions

      expect(result).to include('btn-group')
    end

    it 'includes clone button' do
      result = todo.dt_actions

      expect(result).to include('clone')
      expect(result).to include('/todos/1/clone')
    end

    it 'includes show button' do
      result = todo.dt_actions

      expect(result).to include('Visualizar') # Title from link_show
      expect(result).to include('/todos/1')
    end

    it 'includes edit button' do
      result = todo.dt_actions

      expect(result).to include('edit')
      expect(result).to include('/todos/1/edit')
    end

    it 'includes destroy button with onClick handler' do
      result = todo.dt_actions

      expect(result).to include('destroy')
      expect(result).to include('App.Todo.destroy(this)')
    end

    it 'returns safe HTML' do
      result = todo.dt_actions

      expect(result).to be_html_safe
    end
  end
end
