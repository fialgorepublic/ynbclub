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

ActiveRecord::Schema.define(version: 2019_11_06_134745) do

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "blog_views", force: :cascade do |t|
    t.integer "blog_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.bigint "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean "is_featured", default: false
    t.datetime "feature_date"
    t.boolean "is_published", default: false
    t.boolean "buyer_show", default: false
    t.bigint "user_id"
    t.string "image_url"
    t.string "slug"
    t.boolean "coins_awarded", default: false
    t.index ["slug"], name: "index_blogs_on_slug", unique: true
    t.index ["user_id"], name: "index_blogs_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.bigint "state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state_id"], name: "index_cities_on_state_id"
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

  create_table "commission_histories", force: :cascade do |t|
    t.bigint "user_id"
    t.float "old_income"
    t.float "new_income"
    t.string "order_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_commission_histories_on_user_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.string "subject"
    t.string "body"
    t.bigint "user_id"
    t.bigint "group_id"
    t.text "tags", default: [], array: true
    t.integer "parent_id"
    t.integer "replies_count", default: 0
    t.integer "likes_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_conversations_on_group_id"
    t.index ["user_id"], name: "index_conversations_on_user_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email", default: ""
    t.string "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "districts", force: :cascade do |t|
    t.string "name"
    t.bigint "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_districts_on_city_id"
  end

  create_table "earn_coins", force: :cascade do |t|
    t.string "main_text"
    t.string "how_earn_text"
    t.string "how_spend_text"
    t.string "earn_way"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "coins"
    t.string "price"
  end

  create_table "exchange_histories", force: :cascade do |t|
    t.string "discount_code"
    t.bigint "user_id"
    t.integer "exchanged_coins"
    t.float "rewarded_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_exchange_histories_on_user_id"
  end

  create_table "group_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.bigint "group_category_id"
    t.integer "users_count", default: 0
    t.integer "conversations_count", default: 0
    t.index ["group_category_id"], name: "index_groups_on_group_category_id"
    t.index ["slug"], name: "index_groups_on_slug", unique: true
  end

  create_table "items", force: :cascade do |t|
    t.bigint "order_id"
    t.string "name"
    t.float "amount", default: 0.0
    t.integer "quantity"
    t.float "weight", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_items_on_order_id"
  end

  create_table "joined_groups", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_joined_groups_on_group_id"
    t.index ["user_id"], name: "index_joined_groups_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "blog_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.boolean "archived", default: false
    t.string "source_type"
    t.bigint "source_id"
    t.integer "target_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_type", "source_id"], name: "index_notifications_on_source_type_and_source_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "order_id"
    t.string "order_name"
    t.string "email"
    t.string "ghtk_label"
    t.string "ghtk_status"
    t.string "address"
    t.string "postcode"
    t.string "phone_number"
    t.string "customer_name"
    t.string "total"
    t.string "tracking_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "sent_to_ghtk", default: false
    t.string "order_created_at"
    t.string "fulfilment_status"
    t.string "financial_status"
    t.bigint "city_id"
    t.bigint "district_id"
    t.bigint "province_id"
    t.bigint "ward_id"
    t.integer "picked_phone", default: 0
    t.integer "transport_type", default: 1
    t.string "store"
    t.index ["city_id"], name: "index_orders_on_city_id"
    t.index ["district_id"], name: "index_orders_on_district_id"
    t.index ["province_id"], name: "index_orders_on_province_id"
    t.index ["ward_id"], name: "index_orders_on_ward_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "heading"
    t.string "sub_heading"
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
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

  create_table "permissions", force: :cascade do |t|
    t.bigint "user_id"
    t.string "controller_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "action_name"
    t.index ["user_id"], name: "index_permissions_on_user_id"
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
    t.string "order_id"
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
    t.bigint "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "url"
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

  create_table "provinces", force: :cascade do |t|
    t.string "name"
    t.bigint "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_provinces_on_city_id"
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
    t.integer "ghtk_status"
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

  create_table "snapshots", force: :cascade do |t|
    t.string "step1_avatar_file_name"
    t.string "step1_avatar_content_type"
    t.bigint "step1_avatar_file_size"
    t.datetime "step1_avatar_updated_at"
    t.string "step2_avatar_file_name"
    t.string "step2_avatar_content_type"
    t.bigint "step2_avatar_file_size"
    t.datetime "step2_avatar_updated_at"
    t.string "step3_avatar_file_name"
    t.string "step3_avatar_content_type"
    t.bigint "step3_avatar_file_size"
    t.datetime "step3_avatar_updated_at"
    t.string "step4_avatar_file_name"
    t.string "step4_avatar_content_type"
    t.bigint "step4_avatar_file_size"
    t.datetime "step4_avatar_updated_at"
    t.string "step1_text"
    t.string "step2_text"
    t.string "step3_text"
    t.string "step4_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
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
    t.bigint "avatar_file_size"
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
    t.boolean "banned", default: false
    t.string "discount_code"
    t.integer "share_link_count", default: 0
    t.boolean "moderator"
    t.integer "groups_count", default: 0
    t.integer "conversations_count", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wards", force: :cascade do |t|
    t.string "name"
    t.bigint "district_id"
    t.bigint "province_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["district_id"], name: "index_wards_on_district_id"
    t.index ["province_id"], name: "index_wards_on_province_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "blogs", "users", on_delete: :cascade
  add_foreign_key "cities", "states", on_delete: :cascade
  add_foreign_key "comment_actions", "comments"
  add_foreign_key "comment_actions", "users"
  add_foreign_key "commission_histories", "users", on_delete: :cascade
  add_foreign_key "conversations", "groups", on_delete: :cascade
  add_foreign_key "conversations", "users", on_delete: :cascade
  add_foreign_key "districts", "cities", on_delete: :cascade
  add_foreign_key "exchange_histories", "users", on_delete: :cascade
  add_foreign_key "groups", "group_categories", on_delete: :cascade
  add_foreign_key "items", "orders", on_delete: :cascade
  add_foreign_key "joined_groups", "groups", on_delete: :cascade
  add_foreign_key "joined_groups", "users", on_delete: :cascade
  add_foreign_key "permissions", "users", on_delete: :cascade
  add_foreign_key "point_types", "earn_coins", on_delete: :cascade
  add_foreign_key "profiles", "users"
  add_foreign_key "provinces", "cities", on_delete: :cascade
  add_foreign_key "wards", "districts", on_delete: :cascade
  add_foreign_key "wards", "provinces", on_delete: :cascade
end
