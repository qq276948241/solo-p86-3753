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

ActiveRecord::Schema[8.1].define(version: 2026_06_25_172238) do
  create_table "bookings", force: :cascade do |t|
    t.datetime "cancelled_at"
    t.datetime "created_at", null: false
    t.integer "member_id", null: false
    t.integer "schedule_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["member_id", "schedule_id"], name: "index_bookings_on_member_id_and_schedule_id"
    t.index ["member_id"], name: "index_bookings_on_member_id"
    t.index ["schedule_id"], name: "index_bookings_on_schedule_id"
  end

  create_table "check_ins", force: :cascade do |t|
    t.integer "booking_id", null: false
    t.datetime "checked_in_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_check_ins_on_booking_id", unique: true
  end

  create_table "coaches", force: :cascade do |t|
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "phone"
    t.datetime "updated_at", null: false
    t.index ["phone"], name: "index_coaches_on_phone", unique: true
  end

  create_table "courses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "duration_minutes", default: 60, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "members", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "member_since", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "name", null: false
    t.string "phone", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["phone"], name: "index_members_on_phone", unique: true
  end

  create_table "schedules", force: :cascade do |t|
    t.integer "capacity", default: 12, null: false
    t.integer "coach_id", null: false
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "start_time", null: false
    t.datetime "updated_at", null: false
    t.index ["coach_id", "start_time"], name: "index_schedules_on_coach_id_and_start_time", unique: true
    t.index ["coach_id"], name: "index_schedules_on_coach_id"
    t.index ["course_id"], name: "index_schedules_on_course_id"
  end

  add_foreign_key "bookings", "members"
  add_foreign_key "bookings", "schedules"
  add_foreign_key "check_ins", "bookings"
  add_foreign_key "schedules", "coaches"
  add_foreign_key "schedules", "courses"
end
