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

ActiveRecord::Schema.define(version: 2019_11_21_030436) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.string "town"
    t.string "url"
    t.string "category"
    t.string "type"
  end

  create_table "articles", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.string "url"
    t.date "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "business"
    t.string "title"
    t.text "comments"
    t.float "price_point"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "status"
    t.text "address"
    t.string "url"
    t.boolean "is_public"
    t.string "phone"
    t.string "email"
    t.datetime "deleted_at"
    t.boolean "paperless_billing"
    t.integer "distribution_center_id"
    t.boolean "mark_retail"
    t.float "price_per_ounce"
    t.integer "town_id"
    t.string "tax_id_number"
    t.integer "user_id"
    t.integer "updated_by_id"
  end

  create_table "distribution_centers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "email"
    t.string "contact_point"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "distributors", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "line_items", id: :serial, force: :cascade do |t|
    t.integer "product_id"
    t.text "size"
    t.float "units"
    t.integer "order_id"
    t.boolean "fulfilled"
  end

  create_table "notes", id: :serial, force: :cascade do |t|
    t.integer "contact_id"
    t.integer "user_id"
    t.text "content"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", id: :serial, force: :cascade do |t|
    t.integer "contact_id"
    t.date "delivery_date"
    t.date "fullfilled_on"
    t.text "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "invoice_id"
    t.string "customer_po"
    t.integer "created_by_id"
    t.integer "updated_by_id"
  end

  create_table "products", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "desc"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.integer "position"
    t.string "category"
    t.boolean "is_public"
    t.boolean "in_production"
    t.string "xero_item_code"
  end

  create_table "reports", id: :serial, force: :cascade do |t|
    t.string "report_type"
    t.date "start_date"
    t.date "end_date"
    t.boolean "totals?"
    t.date "last_run"
    t.string "name"
  end

  create_table "salespeople", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "email"
    t.integer "distributor_id"
    t.string "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "towns", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trade_items", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.boolean "is_public"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "description"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.boolean "admin"
    t.boolean "is_public"
    t.text "description"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "deleted_at"
  end

end
