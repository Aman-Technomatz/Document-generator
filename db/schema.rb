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

ActiveRecord::Schema[7.1].define(version: 2024_12_26_095450) do
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

  create_table "documents", force: :cascade do |t|
    t.string "organization_name"
    t.integer "user_id", null: false
    t.string "document_type"
    t.string "remark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "end_position"
    t.string "start_position"
    t.date "start_date"
    t.date "end_date"
    t.string "employee_id"
    t.decimal "ctc"
    t.integer "experience_years"
    t.decimal "current_salary"
    t.text "gratitude"
    t.integer "work_timings"
    t.integer "probation_period"
    t.integer "service_agreement"
    t.integer "annual_leave"
    t.integer "notice_period"
    t.string "hr_name"
    t.string "company_address"
    t.string "city"
    t.string "pincode"
    t.string "country"
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "payslips", force: :cascade do |t|
    t.integer "paid_days"
    t.integer "loss_of_pay_days"
    t.date "pay_date"
    t.decimal "basic_salary"
    t.decimal "income_tax"
    t.decimal "house_rent_allowance"
    t.decimal "provident_fund"
    t.decimal "gross_earnings"
    t.decimal "total_deductions"
    t.decimal "total_net_payable"
    t.date "pay_slip_for_month"
    t.integer "document_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "other_allowance"
    t.index ["document_id"], name: "index_payslips_on_document_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "mobile_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "documents", "users"
  add_foreign_key "payslips", "documents"
end
