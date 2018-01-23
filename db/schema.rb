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

ActiveRecord::Schema.define(version: 20180122034526) do

  create_table "addresses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "address_type"
    t.string   "contact_name"
    t.string   "mobile"
    t.string   "address"
    t.string   "zipcode"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "defaults",     default: false
    t.integer  "order_id"
    t.string   "type"
    t.index ["user_id", "address_type"], name: "index_addresses_on_user_id_and_address_type", using: :btree
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.integer  "weight",           default: 0
    t.integer  "products_counter", default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "ancestry"
    t.index ["ancestry"], name: "index_categories_on_ancestry", using: :btree
    t.index ["title"], name: "index_categories_on_title", using: :btree
  end

  create_table "cities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "level"
    t.integer  "parent_id"
    t.bigint   "area_code"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "data_url"
    t.integer  "count",      default: 0
  end

  create_table "images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "imgable_id"
    t.string   "imgable_type"
    t.string   "name"
    t.integer  "user_id"
    t.string   "filename"
    t.string   "storage"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "weight",       default: 0
    t.index ["imgable_id"], name: "index_images_on_imgable_id", using: :btree
    t.index ["name"], name: "index_images_on_name", using: :btree
    t.index ["weight", "imgable_id"], name: "index_images_on_weight_and_imgable_id", using: :btree
  end

  create_table "member_scores", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "type"
    t.integer  "num"
    t.integer  "user_id"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.integer  "address_id"
    t.string   "order_no"
    t.integer  "amount"
    t.decimal  "total_money", precision: 10, scale: 2
    t.datetime "payment_at"
    t.integer  "payment_id"
    t.string   "status",                               default: "initial"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.index ["order_no"], name: "index_orders_on_order_no", unique: true, using: :btree
    t.index ["payment_id"], name: "index_orders_on_payment_id", using: :btree
    t.index ["user_id"], name: "index_orders_on_user_id", using: :btree
  end

  create_table "payments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "payment_no"
    t.string   "transaction_no"
    t.string   "status",                                      default: "initial"
    t.decimal  "total_money",                  precision: 10
    t.datetime "payment_at"
    t.text     "raw_response",   limit: 65535
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.index ["payment_no"], name: "index_payments_on_payment_no", unique: true, using: :btree
    t.index ["transaction_no"], name: "index_payments_on_transaction_no", using: :btree
    t.index ["user_id"], name: "index_payments_on_user_id", using: :btree
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "category_id"
    t.string   "title"
    t.string   "status",                                             default: "off"
    t.integer  "amount",                                             default: 0
    t.string   "uuid"
    t.decimal  "msrp",                      precision: 10, scale: 2
    t.decimal  "price",                     precision: 10, scale: 2
    t.text     "description", limit: 65535
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.index ["category_id"], name: "index_products_on_category_id", using: :btree
    t.index ["status", "category_id"], name: "index_products_on_status_and_category_id", using: :btree
    t.index ["title"], name: "index_products_on_title", using: :btree
    t.index ["uuid"], name: "index_products_on_uuid", using: :btree
  end

  create_table "profiles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "avatar"
    t.string   "location"
    t.string   "gender"
    t.string   "city"
    t.text     "description", limit: 65535
    t.integer  "age"
    t.integer  "user_id"
    t.date     "birthday"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "shopping_carts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "user_uuid"
    t.integer  "product_id"
    t.integer  "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_shopping_carts_on_user_id", using: :btree
    t.index ["user_uuid"], name: "index_shopping_carts_on_user_uuid", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email"
    t.string   "email_activation_digest"
    t.boolean  "email_verified",          default: false
    t.string   "password_digest",                         null: false
    t.datetime "activated_at"
    t.string   "remember_digest"
    t.integer  "sign_in_count",           default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "name"
    t.string   "mobile"
    t.boolean  "mobile_verified",         default: false
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "open_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.boolean  "admin",                   default: false
    t.string   "uuid"
    t.integer  "sex"
    t.string   "headimgurl"
    t.string   "unionid"
    t.integer  "scores",                  default: 0,     null: false
    t.boolean  "subscribe"
    t.string   "address"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["mobile"], name: "index_users_on_mobile", unique: true, using: :btree
    t.index ["name"], name: "index_users_on_name", unique: true, using: :btree
    t.index ["unionid"], name: "index_users_on_unionid", using: :btree
  end

end
