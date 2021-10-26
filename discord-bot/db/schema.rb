# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_10_27_202912) do

  create_table "event_players", force: :cascade do |t|
    t.bigint "event_id"
    t.integer "discord_user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id", "discord_user_id"], name: "index_event_players_on_event_id_and_discord_user_id", unique: true
    t.index ["event_id"], name: "index_event_players_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer "created_by_discord_user_id", null: false
    t.integer "discord_server_id", null: false
    t.datetime "start_time", null: false
    t.integer "required_players", null: false
    t.text "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "event_players", "events", on_delete: :cascade
end
