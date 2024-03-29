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

ActiveRecord::Schema.define(version: 2020_03_26_194719) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendances", id: :serial, force: :cascade do |t|
    t.string "cid_code"
    t.string "lis_code"
    t.datetime "start_date"
    t.datetime "finish_date"
    t.integer "patient_id"
    t.string "doctor_name"
    t.string "doctor_crm"
    t.string "observations"
    t.integer "health_ensurance_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "report_file_name"
    t.string "report_content_type"
    t.integer "report_file_size"
    t.datetime "report_updated_at"
    t.integer "status"
    t.integer "desease_stage"
    t.index ["health_ensurance_id"], name: "index_attendances_on_health_ensurance_id"
    t.index ["id"], name: "index_attendances_on_id"
    t.index ["patient_id"], name: "index_attendances_on_patient_id"
  end

  create_table "attendances_work_maps", id: :serial, force: :cascade do |t|
    t.integer "attendance_id"
    t.integer "work_map_id"
    t.index ["attendance_id"], name: "index_attendances_work_maps_on_attendance_id"
    t.index ["work_map_id"], name: "index_attendances_work_maps_on_work_map_id"
  end

  create_table "backups", id: :serial, force: :cascade do |t|
    t.datetime "generated_at"
    t.boolean "status"
    t.string "dump_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bottle_status_kinds", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "current_states", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exam_status_changes", id: :serial, force: :cascade do |t|
    t.integer "exam_id"
    t.datetime "change_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "new_status"
    t.index ["exam_id"], name: "index_exam_status_changes_on_exam_id"
    t.index ["user_id"], name: "index_exam_status_changes_on_user_id"
  end

  create_table "exam_status_kinds", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_exam_status_kinds_on_id"
    t.index ["name"], name: "index_exam_status_kinds_on_name"
  end

  create_table "exams", id: :serial, force: :cascade do |t|
    t.integer "offered_exam_id"
    t.date "start_date"
    t.date "finish_date"
    t.integer "attendance_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "report_file_name"
    t.string "report_content_type"
    t.integer "report_file_size"
    t.datetime "report_updated_at"
    t.string "partial_released_report_file_name"
    t.string "partial_released_report_content_type"
    t.integer "partial_released_report_file_size"
    t.datetime "partial_released_report_updated_at"
    t.boolean "was_late"
    t.integer "lag_time"
    t.integer "status"
    t.index ["attendance_id"], name: "index_exams_on_attendance_id"
    t.index ["id"], name: "index_exams_on_id"
    t.index ["offered_exam_id"], name: "index_exams_on_offered_exam_id"
  end

  create_table "exams_internal_codes", force: :cascade do |t|
    t.bigint "internal_code_id"
    t.bigint "exam_id"
    t.index ["exam_id"], name: "index_exams_internal_codes_on_exam_id"
    t.index ["internal_code_id"], name: "index_exams_internal_codes_on_internal_code_id"
  end

  create_table "fields", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_fields_on_id"
    t.index ["name"], name: "index_fields_on_name"
  end

  create_table "fields_users", id: false, force: :cascade do |t|
    t.bigint "field_id", null: false
    t.bigint "user_id", null: false
    t.index ["field_id", "user_id"], name: "index_fields_users_on_field_id_and_user_id"
  end

  create_table "health_ensurances", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_health_ensurances_on_id"
  end

  create_table "hemacounter_reports", force: :cascade do |t|
    t.bigint "subsample_id"
    t.float "volume"
    t.float "leukocyte_total_count"
    t.float "cellularity"
    t.float "pellet_leukocyte_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subsample_id"], name: "index_hemacounter_reports_on_subsample_id"
  end

  create_table "hospitals", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_hospitals_on_id"
  end

  create_table "internal_codes", force: :cascade do |t|
    t.bigint "sample_id"
    t.bigint "field_id"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "attendance_id"
    t.bigint "subsample_id"
    t.index ["attendance_id"], name: "index_internal_codes_on_attendance_id"
    t.index ["field_id"], name: "index_internal_codes_on_field_id"
    t.index ["id"], name: "index_internal_codes_on_id"
    t.index ["sample_id"], name: "index_internal_codes_on_sample_id"
    t.index ["subsample_id"], name: "index_internal_codes_on_subsample_id"
  end

  create_table "internal_codes_work_maps", force: :cascade do |t|
    t.bigint "internal_code_id"
    t.bigint "work_map_id"
    t.index ["internal_code_id"], name: "index_internal_codes_work_maps_on_internal_code_id"
    t.index ["work_map_id"], name: "index_internal_codes_work_maps_on_work_map_id"
  end

  create_table "nanodrop_reports", id: :serial, force: :cascade do |t|
    t.float "concentration"
    t.float "rate_260_280"
    t.float "rate_260_230"
    t.integer "subsample_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_nanodrop_reports_on_id"
    t.index ["subsample_id"], name: "index_nanodrop_reports_on_subsample_id"
  end

  create_table "offered_exams", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "field_id"
    t.boolean "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "refference_date"
    t.string "mnemonyc"
    t.integer "group"
    t.index ["field_id"], name: "index_offered_exams_on_field_id"
    t.index ["id"], name: "index_offered_exams_on_id"
  end

  create_table "patients", id: :serial, force: :cascade do |t|
    t.string "name"
    t.date "birth_date"
    t.string "mother_name"
    t.string "medical_record"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "hospital_id"
    t.text "observations"
    t.index ["id"], name: "index_patients_on_id"
    t.index ["medical_record"], name: "index_patients_on_medical_record"
    t.index ["name"], name: "index_patients_on_name"
  end

  create_table "products", force: :cascade do |t|
    t.string "lot"
    t.date "shelf_life"
    t.boolean "is_expired"
    t.integer "amount"
    t.bigint "current_state_id"
    t.string "location"
    t.string "tag"
    t.boolean "has_shelf_life"
    t.boolean "has_tag"
    t.date "open_at"
    t.date "finished_at"
    t.bigint "stock_entry_id"
    t.bigint "brand_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "stock_product_id"
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["current_state_id"], name: "index_products_on_current_state_id"
    t.index ["stock_entry_id"], name: "index_products_on_stock_entry_id"
    t.index ["stock_product_id"], name: "index_products_on_stock_product_id"
  end

  create_table "qubit_reports", id: :serial, force: :cascade do |t|
    t.float "concentration"
    t.integer "subsample_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_qubit_reports_on_id"
    t.index ["subsample_id"], name: "index_qubit_reports_on_subsample_id"
  end

  create_table "release_checks", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "release_id"
    t.boolean "has_confirmed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["release_id"], name: "index_release_checks_on_release_id"
    t.index ["user_id"], name: "index_release_checks_on_user_id"
  end

  create_table "releases", force: :cascade do |t|
    t.string "name"
    t.string "tag"
    t.string "message"
    t.boolean "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sample_kinds", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "acronym"
    t.integer "refference_index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_sample_kinds_on_id"
    t.index ["name"], name: "index_sample_kinds_on_name"
  end

  create_table "samples", id: :serial, force: :cascade do |t|
    t.integer "sample_kind_id"
    t.boolean "has_subsample"
    t.date "entry_date"
    t.date "collection_date"
    t.string "refference_label"
    t.integer "attendance_id"
    t.string "storage_location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "patient_id"
    t.text "receipt_notice"
    t.index ["attendance_id"], name: "index_samples_on_attendance_id"
    t.index ["id"], name: "index_samples_on_id"
    t.index ["patient_id"], name: "index_samples_on_patient_id"
    t.index ["sample_kind_id"], name: "index_samples_on_sample_kind_id"
  end

  create_table "stock_entries", force: :cascade do |t|
    t.date "entry_date"
    t.bigint "responsible_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "stock_product_id"
    t.integer "product_amount"
    t.index ["responsible_id"], name: "index_stock_entries_on_responsible_id"
    t.index ["stock_product_id"], name: "index_stock_entries_on_stock_product_id"
  end

  create_table "stock_outs", force: :cascade do |t|
    t.bigint "stock_product_id"
    t.bigint "product_id"
    t.date "date"
    t.bigint "responsible_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_stock_outs_on_product_id"
    t.index ["responsible_id"], name: "index_stock_outs_on_responsible_id"
    t.index ["stock_product_id"], name: "index_stock_outs_on_stock_product_id"
  end

  create_table "stock_products", force: :cascade do |t|
    t.string "name"
    t.float "first_warn_at"
    t.float "danger_warn_at"
    t.string "mv_code"
    t.bigint "field_id"
    t.boolean "is_shared"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "unit_of_measurement"
    t.index ["field_id"], name: "index_stock_products_on_field_id"
  end

  create_table "subsample_kinds", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "acronym"
    t.integer "refference_index"
    t.index ["id"], name: "index_subsample_kinds_on_id"
    t.index ["name"], name: "index_subsample_kinds_on_name"
  end

  create_table "subsamples", id: :serial, force: :cascade do |t|
    t.string "storage_location"
    t.string "refference_label"
    t.integer "subsample_kind_id"
    t.integer "sample_id"
    t.datetime "collection_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "attendance_id"
    t.bigint "patient_id"
    t.string "observations"
    t.index ["attendance_id"], name: "index_subsamples_on_attendance_id"
    t.index ["id"], name: "index_subsamples_on_id"
    t.index ["patient_id"], name: "index_subsamples_on_patient_id"
    t.index ["sample_id"], name: "index_subsamples_on_sample_id"
    t.index ["subsample_kind_id"], name: "index_subsamples_on_subsample_kind_id"
  end

  create_table "suggestion_progresses", force: :cascade do |t|
    t.bigint "suggestion_id"
    t.string "old_status"
    t.string "new_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["suggestion_id"], name: "index_suggestion_progresses_on_suggestion_id"
  end

  create_table "suggestions", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.bigint "requester_id"
    t.integer "current_status"
    t.datetime "start_at"
    t.datetime "finish_date"
    t.integer "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["requester_id"], name: "index_suggestions_on_requester_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "login"
    t.string "password_digest"
    t.string "name"
    t.boolean "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_login_at"
    t.integer "kind"
    t.index ["id"], name: "index_users_on_id"
  end

  create_table "work_maps", id: :serial, force: :cascade do |t|
    t.date "date"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "map_file_name"
    t.string "map_content_type"
    t.integer "map_file_size"
    t.datetime "map_updated_at"
    t.index ["id"], name: "index_work_maps_on_id"
  end

  add_foreign_key "attendances", "health_ensurances"
  add_foreign_key "attendances", "patients"
  add_foreign_key "exam_status_changes", "exams"
  add_foreign_key "exams", "attendances"
  add_foreign_key "exams", "offered_exams"
  add_foreign_key "hemacounter_reports", "subsamples"
  add_foreign_key "internal_codes", "fields"
  add_foreign_key "internal_codes", "samples"
  add_foreign_key "nanodrop_reports", "subsamples"
  add_foreign_key "offered_exams", "fields"
  add_foreign_key "patients", "hospitals"
  add_foreign_key "products", "brands"
  add_foreign_key "products", "current_states"
  add_foreign_key "products", "stock_entries"
  add_foreign_key "qubit_reports", "subsamples"
  add_foreign_key "release_checks", "releases"
  add_foreign_key "release_checks", "users"
  add_foreign_key "samples", "attendances"
  add_foreign_key "samples", "patients"
  add_foreign_key "samples", "sample_kinds"
  add_foreign_key "stock_entries", "users", column: "responsible_id"
  add_foreign_key "stock_outs", "products"
  add_foreign_key "stock_outs", "stock_products"
  add_foreign_key "stock_outs", "users", column: "responsible_id"
  add_foreign_key "stock_products", "fields"
  add_foreign_key "subsamples", "patients"
  add_foreign_key "subsamples", "samples"
  add_foreign_key "subsamples", "subsample_kinds"
  add_foreign_key "suggestion_progresses", "suggestions"
  add_foreign_key "suggestions", "users", column: "requester_id"
end
