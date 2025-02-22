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

ActiveRecord::Schema[7.2].define(version: 2024_12_20_160558) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_experts", id: false, force: :cascade do |t|
    t.bigint "expert_id", null: false
    t.bigint "category_id", null: false
  end

  create_table "course_modules", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "course_modules_experts", id: false, force: :cascade do |t|
    t.bigint "expert_id", null: false
    t.bigint "course_module_id", null: false
  end

  create_table "experts", force: :cascade do |t|
    t.string "salutation"
    t.string "title"
    t.string "first_name"
    t.string "last_name"
    t.string "nationality"
    t.string "phone_number"
    t.string "email"
    t.string "location"
    t.string "availability"
    t.text "china_experience"
    t.string "institution"
    t.text "cooperation_opportunity"
    t.text "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remark_travel_willingness"
    t.string "extra_category"
    t.integer "hourly_rate"
    t.integer "daily_rate"
    t.boolean "institution_association"
    t.string "teaching_languages", default: [], array: true
    t.string "communication_languages", default: [], array: true
    t.string "travel_willingnesses", default: [], array: true
  end

  create_table "experts_projects", id: false, force: :cascade do |t|
    t.bigint "expert_id", null: false
    t.bigint "project_id", null: false
  end

  create_table "one_time_links", force: :cascade do |t|
    t.string "token"
    t.boolean "used"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "project_name"
    t.string "main_topics"
    t.date "start_date"
    t.date "end_date"
    t.string "project_type"
    t.string "client"
    t.string "location"
    t.string "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "initiated", default: false
    t.bigint "expert_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["expert_id"], name: "index_users_on_expert_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "users", "experts"
end
