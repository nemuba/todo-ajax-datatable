# frozen_string_literal: true

class CreateTodos < ActiveRecord::Migration[5.2]
  def up
    enable_extension :pg_trgm

    create_table :todos do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.boolean :done, null: false, default: false

      t.timestamps
    end

    add_index :todos, :title, name: 'todos_title_idx', using: :gin, opclass: { title: :gin_trgm_ops }
    add_index :todos, :description, name: 'todos_description_idx', using: :gin, opclass: { description: :gin_trgm_ops }
    add_index :todos, :done, name: 'todos_done_idx'
  end

  def down
    disable_extension :pg_trgm

    drop_table :todos
  end
end
