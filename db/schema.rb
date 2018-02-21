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

ActiveRecord::Schema.define(version: 20180216232819) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "issue_transactions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "issue_id"
    t.integer "amount"
    t.boolean "completed"
    t.boolean "cancelled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_issue_transactions_on_issue_id"
    t.index ["user_id"], name: "index_issue_transactions_on_user_id"
  end

  create_table "issues", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "status"
    t.bigint "parent_id"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_issues_on_parent_id"
    t.index ["project_id"], name: "index_issues_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "status"
    t.bigint "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link"
    t.index ["owner_id"], name: "index_projects_on_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.float "balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
