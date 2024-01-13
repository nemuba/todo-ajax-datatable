# frozen_string_literal: true

class TodoDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegators :@view, :link_to, :edit_todo_path

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: 'Todo.id', cond: :eq },
      title: { source: 'Todo.title', cond: :like },
      description: { source: 'Todo.description', cond: :like },
      done: { source: 'Todo.done', cond: :like },
      created_at: { source: 'Todo.created_at', cond: :like },
      updated_at: { source: 'Todo.updated_at', cond: :like }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        title: record.title,
        description: record.description,
        done: record.decorate.done,
        items: record.items.size,
        created_at: record.decorate.created_at,
        updated_at: record.decorate.updated_at,
        actions: record.decorate.dt_actions,
        DT_RowId: record.id
      }
    end
  end

  def get_raw_records
    Todo.includes(:items).all
  end
end
