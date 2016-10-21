# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20161018110817) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.date     "start_date"
    t.date     "stop_date"
    t.decimal  "total",      precision: 10, scale: 2
    t.integer  "user_id"
    t.integer  "flat_id"
  end

  add_index "accounts", ["flat_id"], name: "index_accounts_on_flat_id", using: :btree
  add_index "accounts", ["user_id"], name: "index_accounts_on_user_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "unit"
    t.boolean  "is_counter",  default: false
  end

  create_table "counters", force: :cascade do |t|
    t.integer "account_id"
    t.integer "utility_id"
    t.float   "value",      default: 0.0
  end

  add_index "counters", ["account_id"], name: "index_counters_on_account_id", using: :btree
  add_index "counters", ["utility_id"], name: "index_counters_on_utility_id", using: :btree

  create_table "flats", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "address"
    t.string   "payer_firstname"
    t.string   "payer_middlename"
    t.string   "payer_lastname"
    t.float    "total_area"
    t.float    "heated_area"
    t.integer  "residents_number"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "flats", ["user_id"], name: "index_flats_on_user_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "utility_id"
    t.integer  "months_number",                              default: 1
    t.decimal  "amount",            precision: 10, scale: 2,             null: false
    t.float    "tariff_value",                                           null: false
    t.float    "quantity",                                               null: false
    t.float    "old_value_counter"
    t.float    "new_value_counter"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
  end

  add_index "payments", ["account_id"], name: "index_payments_on_account_id", using: :btree
  add_index "payments", ["utility_id"], name: "index_payments_on_utility_id", using: :btree

  create_table "tariffs", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "name"
    t.decimal  "value",       precision: 10, scale: 2, null: false
    t.date     "start_date"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "tariffs", ["category_id"], name: "index_tariffs_on_category_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.string   "name"
    t.string   "location"
    t.string   "image_url"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true, using: :btree
  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

  create_table "utilities", force: :cascade do |t|
    t.integer  "flat_id"
    t.integer  "category_id"
    t.integer  "tariff_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "description_counter"
    t.float    "start_value_counter"
    t.float    "last_value_counter",  default: 0.0
  end

  add_index "utilities", ["category_id"], name: "index_utilities_on_category_id", using: :btree
  add_index "utilities", ["flat_id"], name: "index_utilities_on_flat_id", using: :btree
  add_index "utilities", ["tariff_id"], name: "index_utilities_on_tariff_id", using: :btree

  add_foreign_key "accounts", "flats"
  add_foreign_key "accounts", "users"
  add_foreign_key "counters", "accounts"
  add_foreign_key "counters", "utilities"
  add_foreign_key "flats", "users"
  add_foreign_key "payments", "accounts"
  add_foreign_key "payments", "utilities"
  add_foreign_key "tariffs", "categories"
  add_foreign_key "utilities", "categories"
  add_foreign_key "utilities", "flats"
  add_foreign_key "utilities", "tariffs"
end
