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

ActiveRecord::Schema.define(version: 2018_05_25_174848) do

  create_table "room_visits", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.datetime "date"
    t.integer "status"
    t.bigint "visit_id"
    t.bigint "room_id"
    t.bigint "persona_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["persona_id"], name: "index_room_visits_on_persona_id"
    t.index ["room_id"], name: "index_room_visits_on_room_id"
    t.index ["visit_id"], name: "index_room_visits_on_visit_id"
  end

  create_table "rooms", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.bigint "departamento_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["departamento_id"], name: "index_rooms_on_departamento_id"
  end

  create_table "visits", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "departamento_id"
    t.bigint "institution_id"
    t.string "resp_name"
    t.string "resp_phone"
    t.string "resp_email"
    t.datetime "requested_date"
    t.integer "transport_type"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["departamento_id"], name: "index_visits_on_departamento_id"
    t.index ["institution_id"], name: "index_visits_on_institution_id"
  end

  add_foreign_key "room_visits", "rooms"
  add_foreign_key "room_visits", "visits"
end
