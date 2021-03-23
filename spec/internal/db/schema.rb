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

ActiveRecord::Schema.define(version: 0) do

  create_table "constrained_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade, minibars: true do |t|
    t.integer "unique_number"
    t.index ["unique_number"], name: "index_constrained_records_on_unique_number", unique: true
  end

  create_table "habtm_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade, minibars: true do |t|
  end

  create_table "serialized_column_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade, minibars: true do |t|
    t.text "tags"
  end

  create_table "source_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade, minibars: true do |t|
    t.string "name"
    t.integer "counter"
    t.string "type"
    t.json "json"
    t.bigint "target_assignment_id"
    t.bigint "user_id"
    t.string "attachable_type"
    t.bigint "attachable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["attachable_type", "attachable_id"], name: "index_source_records_on_attachable_type_and_attachable_id"
    t.index ["target_assignment_id"], name: "index_source_records_on_target_assignment_id"
    t.index ["user_id"], name: "index_source_records_on_user_id"
  end

  create_table "minibars_commit_entries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade, minibars: :commit_entries do |t|
    t.integer "record_id"
    t.string "table_name"
    t.string "operation", null: false
    t.integer "commit_id"
    t.string "session"
    t.datetime "created_at"
    t.index ["commit_id"], name: "index_minibars_commit_entries_on_commit_id"
    t.index ["operation", "commit_id"], name: "index_minibars_commit_entries_on_operation_and_commit_id"
    t.index ["record_id", "table_name"], name: "index_minibars_commit_entries_on_record_id_and_table_name"
  end

  create_table "target_assignments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade, minibars: true do |t|
    t.bigint "source_record_id"
    t.bigint "target_id"
    t.integer "counter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_record_id"], name: "index_target_assignments_on_source_record_id"
    t.index ["target_id"], name: "index_target_assignments_on_target_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade, minibars: false do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
