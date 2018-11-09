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

ActiveRecord::Schema.define(version: 2018_11_07_202850) do

  create_table "departments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "room_visits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "date"
    t.integer "status"
    t.bigint "visit_id"
    t.bigint "room_id"
    t.bigint "persona_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "group"
    t.index ["persona_id"], name: "index_room_visits_on_persona_id"
    t.index ["room_id"], name: "index_room_visits_on_room_id"
    t.index ["visit_id"], name: "index_room_visits_on_visit_id"
  end

  create_table "rooms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.bigint "department_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_rooms_on_department_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email"
    t.integer "user_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "departments"
  end

  create_table "visit_files", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "visit_id"
    t.string "name"
    t.string "file"
    t.integer "file_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["visit_id"], name: "index_visit_files_on_visit_id"
  end

  create_table "visit_people", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "visit_id"
    t.string "name"
    t.integer "person_type"
    t.datetime "check_in"
    t.datetime "check_out"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["visit_id"], name: "index_visit_people_on_visit_id"
  end

  create_table "visits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "department_id"
    t.string "institution"
    t.string "resp_name"
    t.string "resp_phone"
    t.string "resp_email"
    t.integer "transport_type"
    t.integer "status"
    t.string "token"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "career"
    t.text "reason"
    t.integer "visit_type"
    t.integer "people_approx"
    t.boolean "split_in_groups", default: false
    t.index ["department_id"], name: "index_visits_on_department_id"
  end

  add_foreign_key "room_visits", "visits"
  add_foreign_key "visit_files", "visits"
  add_foreign_key "visit_people", "visits"
end
