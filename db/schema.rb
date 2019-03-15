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

ActiveRecord::Schema.define(version: 20190314192602) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_invites", force: :cascade do |t|
    t.string "invite_email"
    t.bigint "account_id"
    t.integer "response", default: 0
    t.datetime "responded_at"
    t.string "response_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_invites_on_account_id"
  end

  create_table "account_transfers", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "original_owner_id"
    t.string "target_owner"
    t.integer "response", default: 0
    t.datetime "responded_at"
    t.string "response_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_transfers_on_account_id"
    t.index ["original_owner_id"], name: "index_account_transfers_on_original_owner_id"
    t.index ["response_token"], name: "index_account_transfers_on_response_token"
    t.index ["target_owner"], name: "index_account_transfers_on_target_owner"
  end

  create_table "accounts", force: :cascade do |t|
    t.bigint "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["owner_id"], name: "index_accounts_on_owner_id"
  end

  create_table "accounts_users", id: false, force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "user_id", null: false
    t.index ["account_id"], name: "index_accounts_users_on_account_id"
    t.index ["user_id"], name: "index_accounts_users_on_user_id"
  end

  create_table "hits", force: :cascade do |t|
    t.string "hit_type"
    t.string "location"
    t.string "language"
    t.string "encoding"
    t.string "title"
    t.string "color_depth"
    t.string "screen_res"
    t.string "viewport"
    t.string "tracking_id"
    t.string "client_id"
    t.bigint "site_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id"], name: "index_hits_on_site_id"
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "sites", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.string "screenshot_url"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_sites_on_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "admin", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "account_invites", "accounts"
  add_foreign_key "account_transfers", "accounts"
  add_foreign_key "account_transfers", "users", column: "original_owner_id"
  add_foreign_key "accounts", "users", column: "owner_id"
  add_foreign_key "hits", "sites"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "sites", "accounts"
end
