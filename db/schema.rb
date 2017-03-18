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



ActiveRecord::Schema.define(version: 20170318194131) do
  
#ActiveRecord::Schema.define(version: 20170318184911) do

# ActiveRecord::Schema.define(version: 20170318173013) do


  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "drill_id"
    t.index ["drill_id"], name: "index_answers_on_drill_id", using: :btree
  end

  create_table "drills", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "level"
    t.integer  "points"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "group_id"
    t.integer  "user_id"
    t.integer  "completed"
    t.index ["group_id"], name: "index_drills_on_group_id", using: :btree
    t.index ["user_id"], name: "index_drills_on_user_id", using: :btree
  end

  create_table "groups", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.boolean  "is_admin",             default: false
    t.string   "password_digest"
    t.boolean  "is_validated",         default: false
    t.integer  "score"
    t.string   "password_reset_token"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "uid"
    t.string   "provider"
    t.string   "oauth_token"
    t.string   "oauth_secret"
    t.text     "oauth_raw_data"
    t.datetime "reset_sent_at"
    t.index ["uid", "provider", "email"], name: "index_users_on_uid_and_provider_and_email", using: :btree
  end

  add_foreign_key "answers", "drills"
  add_foreign_key "drills", "groups"
  add_foreign_key "drills", "users"
end
