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

ActiveRecord::Schema.define(version: 2016_06_10_141519) do

  create_table "filters", force: :cascade do |t|
    t.integer "rule_id", null: false
    t.string "value", null: false
    t.string "regex", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "verb"
    t.index ["rule_id"], name: "index_filters_on_rule_id"
  end

  create_table "handlers", force: :cascade do |t|
    t.integer "rule_id", null: false
    t.string "service_name", null: false
    t.text "settings", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rule_id"], name: "index_handlers_on_rule_id"
  end

  create_table "rules", force: :cascade do |t|
    t.string "name", null: false
    t.integer "shop_id", null: false
    t.string "topic", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_rules_on_shop_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "shopify_domain", null: false
    t.string "shopify_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true
  end

end
