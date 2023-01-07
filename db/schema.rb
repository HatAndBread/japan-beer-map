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

ActiveRecord::Schema[7.0].define(version: 2023_01_07_093828) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "places", force: :cascade do |t|
    t.decimal "lng", precision: 10, scale: 6
    t.decimal "lat", precision: 10, scale: 6
    t.string "website"
    t.string "google_maps_url"
    t.jsonb "periods"
    t.string "name", null: false
    t.string "address"
    t.string "phone"
    t.string "google_place_id"
    t.boolean "is_restaurant"
    t.boolean "has_food"
    t.boolean "is_shop"
    t.boolean "is_bar"
    t.jsonb "google_photos", default: [], null: false
    t.boolean "is_brewery"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
