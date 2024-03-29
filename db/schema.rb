# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_11_29_011921) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "items", force: :cascade do |t|
    t.string "description", null: false
    t.boolean "status", default: false, null: false
    t.bigint "todo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["todo_id"], name: "index_items_on_todo_id"
  end

  create_table "todos", force: :cascade do |t|
    t.string "title", null: false
    t.string "description", null: false
    t.boolean "done", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["description"], name: "todos_description_idx", opclass: :gin_trgm_ops, using: :gin
    t.index ["done"], name: "todos_done_idx"
    t.index ["title"], name: "todos_title_idx", opclass: :gin_trgm_ops, using: :gin
  end

  add_foreign_key "items", "todos"
end
