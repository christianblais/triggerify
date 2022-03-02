# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_02_11_205713) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "filters", id: :serial, force: :cascade do |t|
    t.integer "rule_id", null: false
    t.string "value", null: false
    t.string "regex", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "verb"
    t.index ["rule_id"], name: "index_filters_on_rule_id"
  end

  create_table "handlers", id: :serial, force: :cascade do |t|
    t.integer "rule_id", null: false
    t.string "service_name", null: false
    t.text "settings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "handle_count", default: 0, null: false
    t.index ["rule_id"], name: "index_handlers_on_rule_id"
  end

  create_table "rules", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "shop_id", null: false
    t.string "topic", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enabled", default: true, null: false
    t.index ["shop_id"], name: "index_rules_on_shop_id"
  end

  create_table "shops", id: :serial, force: :cascade do |t|
    t.string "shopify_domain", null: false
    t.string "shopify_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "interacted_at", default: "1970-01-01 00:00:00", null: false
    t.string "access_scopes"
    t.index ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true
  end

  add_foreign_key "filters", "rules"
  add_foreign_key "handlers", "rules"
  add_foreign_key "rules", "shops"
end
