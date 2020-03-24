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

ActiveRecord::Schema.define(version: 20160422211220) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "zipcode"
    t.string   "phone"
    t.string   "alternative_phone"
    t.string   "company"
    t.string   "state"
    t.string   "country"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string  "name"
    t.integer "parent_id"
    t.integer "lft",                        null: false
    t.integer "rgt",                        null: false
    t.integer "depth",          default: 0, null: false
    t.integer "children_count", default: 0, null: false
  end

  add_index "categories", ["lft"], name: "index_categories_on_lft", using: :btree
  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree
  add_index "categories", ["rgt"], name: "index_categories_on_rgt", using: :btree

  create_table "course_batches", force: :cascade do |t|
    t.integer  "course_level_id"
    t.integer  "capacity"
    t.string   "description"
    t.string   "instructor"
    t.integer  "duration"
    t.string   "type"
    t.integer  "frequency"
    t.integer  "start_day"
    t.integer  "start_month"
    t.integer  "start_week"
    t.datetime "start_date"
    t.datetime "end_date"
    t.time     "start_time1"
    t.time     "start_time2"
    t.time     "start_time3"
    t.time     "end_time1"
    t.time     "end_time2"
    t.time     "end_time3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_batches", ["course_level_id"], name: "index_course_batches_on_course_level_id", using: :btree

  create_table "course_levels", force: :cascade do |t|
    t.integer  "course_provider_id"
    t.integer  "capacity"
    t.integer  "level"
    t.string   "level_name"
    t.decimal  "price",              precision: 12, scale: 2
    t.string   "image_hashed_id"
    t.string   "coach_name"
    t.string   "description"
    t.string   "instructions"
    t.string   "prerequisites"
    t.string   "inclusions"
    t.integer  "duration"
    t.integer  "sessions"
    t.integer  "session_duration"
    t.boolean  "has_batches"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_levels", ["course_provider_id"], name: "index_course_levels_on_course_provider_id", using: :btree

  create_table "course_providers", force: :cascade do |t|
    t.integer  "course_id"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "address1"
    t.string   "address2"
    t.string   "zipcode"
    t.string   "phone"
    t.string   "alternative_phone"
    t.string   "company"
    t.string   "locality"
    t.string   "nearby"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "company_image_hashed_id"
    t.string   "location_image_hashed_id"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_providers", ["course_id"], name: "index_course_providers_on_course_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "instructions"
    t.string   "prerequisites"
    t.string   "inclusions"
    t.string   "tags"
    t.integer  "category_id"
    t.string   "main_image_hashed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",               default: true
  end

  add_index "courses", ["category_id"], name: "index_courses_on_category_id", using: :btree

  create_table "enquiries", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "from_email"
    t.string   "from_name"
    t.string   "from_phone"
    t.string   "about"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enrollments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "course_level_id"
    t.integer  "course_batch_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "last_ip_address"
    t.string   "email"
    t.string   "phone"
    t.integer  "billing_address_id_id"
    t.string   "currency"
    t.decimal  "actual_amount"
    t.decimal  "adjusted_amount"
    t.decimal  "final_amount"
    t.integer  "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "enrollments", ["course_batch_id"], name: "index_enrollments_on_course_batch_id", using: :btree
  add_index "enrollments", ["course_level_id"], name: "index_enrollments_on_course_level_id", using: :btree
  add_index "enrollments", ["user_id"], name: "index_enrollments_on_user_id", using: :btree

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "access_token"
    t.string   "refresh_token"
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.string   "nick_name"
    t.string   "image"
    t.string   "phone"
    t.string   "urls"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "identities", ["uid"], name: "index_identities_on_uid", using: :btree
  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "newsletters", force: :cascade do |t|
    t.string   "email"
    t.integer  "user_id"
    t.string   "medium"
    t.datetime "unsubscribed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "newsletters", ["user_id"], name: "index_newsletters_on_user_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "role"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "phone_number"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["phone_number"], name: "index_users_on_phone_number", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "identities", "users"
end
