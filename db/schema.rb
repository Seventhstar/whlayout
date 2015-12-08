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

ActiveRecord::Schema.define(version: 20151208123455) do

  create_table "elements", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "layout_elements", force: :cascade do |t|
    t.integer  "layout_id"
    t.integer  "element_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "count"
  end

  create_table "layouts", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "search_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "keywords"
  end

  create_table "search_sites", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "items"
    t.string   "id_method"
    t.string   "id_field"
    t.string   "id_split"
    t.string   "title"
    t.string   "link_pref"
    t.string   "detail"
    t.string   "href"
    t.string   "price"
    t.string   "cookie"
    t.string   "warranty_css"
    t.string   "warranty_method"
    t.string   "warranty_split"
    t.string   "title_field"
    t.string   "disabled"
  end

  create_table "search_urls", force: :cascade do |t|
    t.string   "url"
    t.integer  "search_site_id"
    t.integer  "search_category_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "disabled",           default: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email",             default: "",    null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "progress"
  end

  create_table "whouse_elements", force: :cascade do |t|
    t.integer  "whouse_id"
    t.integer  "element_id"
    t.integer  "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "whouses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
