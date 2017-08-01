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

ActiveRecord::Schema.define(version: 20170120095349) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_categories_on_deleted_at", using: :btree
  end

  create_table "menus", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.float    "price"
    t.integer  "tenant_id"
    t.integer  "category_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "picture"
    t.boolean  "availability", default: true
    t.datetime "deleted_at"
    t.index ["category_id"], name: "index_menus_on_category_id", using: :btree
    t.index ["deleted_at"], name: "index_menus_on_deleted_at", using: :btree
    t.index ["tenant_id"], name: "index_menus_on_tenant_id", using: :btree
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "message"
    t.boolean  "is_read",     default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "entity_id"
    t.string   "entity_type"
    t.index ["entity_type", "entity_id"], name: "index_notifications_on_entity_type_and_entity_id", using: :btree
    t.index ["user_id"], name: "index_notifications_on_user_id", using: :btree
  end

  create_table "options", force: :cascade do |t|
    t.string   "option_name"
    t.string   "option_value"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "order_details", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "menu_id"
    t.integer  "qty"
    t.text     "notes"
    t.string   "flag"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.float    "price"
    t.string   "comment"
    t.integer  "tenant_id"
    t.string   "menu_name"
    t.boolean  "buffet",     default: false
    t.index ["menu_id"], name: "index_order_details_on_menu_id", using: :btree
    t.index ["order_id"], name: "index_order_details_on_order_id", using: :btree
    t.index ["tenant_id"], name: "index_order_details_on_tenant_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.string   "code"
    t.string   "customer"
    t.integer  "user_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "state"
    t.integer  "pax"
    t.boolean  "buffet",       default: false
    t.float    "buffet_price"
    t.index ["user_id"], name: "index_orders_on_user_id", using: :btree
  end

  create_table "permissions", force: :cascade do |t|
    t.string   "name"
    t.string   "subject_class"
    t.string   "action"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "role_permissions", id: false, force: :cascade do |t|
    t.integer  "role_id"
    t.integer  "permission_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["permission_id"], name: "index_role_permissions_on_permission_id", using: :btree
    t.index ["role_id"], name: "index_role_permissions_on_role_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "sales", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "user_id"
    t.float    "amount"
    t.string   "payment_method"
    t.float    "payment"
    t.string   "status"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "reference_number"
    t.integer  "discount"
    t.float    "discount_amount"
    t.float    "tax",              default: 0.0
    t.float    "service",          default: 0.0
    t.index ["order_id"], name: "index_sales_on_order_id", using: :btree
    t.index ["user_id"], name: "index_sales_on_user_id", using: :btree
  end

  create_table "tenants", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "user_id"
    t.string   "phone_number"
    t.string   "identity_number"
    t.string   "slot"
    t.datetime "deleted_at"
    t.boolean  "include_inventory", default: false
    t.index ["deleted_at"], name: "index_tenants_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_tenants_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email",                             default: "", null: false
    t.string   "encrypted_password",                default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                   default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "role_id"
    t.string   "authentication_token",   limit: 30
    t.string   "unique_session_id",      limit: 20
    t.string   "web_player_id"
    t.datetime "deleted_at"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["role_id"], name: "index_users_on_role_id", using: :btree
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

  add_foreign_key "notifications", "users"
  add_foreign_key "users", "roles"
end
