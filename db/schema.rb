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

ActiveRecord::Schema.define(version: 20181130121343) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blog_views", force: :cascade do |t|
    t.integer "user_id"
    t.integer "blog_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "blog_id"], name: "index_blog_views_on_user_id_and_blog_id", unique: true
  end

  create_table "blogs", force: :cascade do |t|
    t.string "title"
    t.string "promote_post"
    t.text "description"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean "is_featured", default: false
    t.datetime "feature_date"
    t.boolean "is_published", default: false
    t.boolean "buyer_show", default: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_blogs_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "data_fingerprint"
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "comment_actions", force: :cascade do |t|
    t.boolean "like"
    t.bigint "user_id"
    t.bigint "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_comment_actions_on_comment_id"
    t.index ["user_id"], name: "index_comment_actions_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "message"
    t.integer "user_id"
    t.integer "blog_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email", default: ""
    t.string "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "earn_coins", force: :cascade do |t|
    t.string "main_text"
    t.string "how_earn_text"
    t.string "how_spend_text"
    t.string "earn_way"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "blog_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "partner_informations", force: :cascade do |t|
    t.string "store_name"
    t.string "phone_no"
    t.text "address"
    t.string "id_number"
    t.string "bank_name"
    t.string "account_number"
    t.string "account_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer "payment_code"
    t.date "payment_date"
    t.float "amount"
    t.string "recipient_name"
    t.string "email"
    t.string "number_math"
    t.string "status"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "point_types", force: :cascade do |t|
    t.string "name"
    t.float "point"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_deleted", default: false
    t.bigint "earn_coin_id"
    t.index ["earn_coin_id"], name: "index_point_types_on_earn_coin_id"
  end

  create_table "points", force: :cascade do |t|
    t.integer "user_id"
    t.integer "point_type_id"
    t.float "point_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitee"
    t.integer "share_url_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "title"
    t.string "product_id"
    t.float "price"
    t.string "currency"
    t.integer "blog_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "phone_number"
    t.string "first_name"
    t.string "surname"
    t.string "gender"
    t.date "date_of_birth"
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "state"
    t.string "city"
    t.string "zip_code"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "security_number"
    t.string "account_number"
    t.string "acc_holder_name"
    t.string "bank_name"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "referral_sales", force: :cascade do |t|
    t.integer "user_id"
    t.string "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "email"
    t.text "address"
    t.string "shopdomain"
    t.string "price"
    t.boolean "is_approved", default: false
    t.string "order_no"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.float "min_payment"
    t.integer "cookie_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "share_urls", force: :cascade do |t|
    t.string "url"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "blog_id"
    t.string "url_type"
  end

  create_table "share_with_friends", force: :cascade do |t|
    t.string "reward_text"
    t.string "earn_coins_text"
    t.string "fb_btn_text"
    t.string "twitter_btn_text"
    t.string "email_btn_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role_id"
    t.string "referral"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean "social_login", default: false
    t.float "commission"
    t.string "phone_number"
    t.string "shop_no"
    t.string "money"
    t.boolean "is_activated", default: false
    t.boolean "is_shopify_user", default: false
    t.string "identity_card"
    t.string "surplus"
    t.string "paid"
    t.float "total_income"
    t.string "status"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "blogs", "users", on_delete: :cascade
  add_foreign_key "comment_actions", "comments"
  add_foreign_key "comment_actions", "users"
  add_foreign_key "point_types", "earn_coins", on_delete: :cascade
  add_foreign_key "profiles", "users"
end
