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

ActiveRecord::Schema.define(version: 20150217164132) do

  create_table "generated_memes", force: :cascade do |t|
    t.string   "top",         limit: 255
    t.string   "bottom",      limit: 255
    t.integer  "meme_id",     limit: 4
    t.string   "slug",        limit: 255
    t.string   "img_hash",    limit: 255
    t.integer  "user_id",     limit: 4
    t.integer  "views",       limit: 4
    t.integer  "views_day",   limit: 4
    t.integer  "views_week",  limit: 4
    t.integer  "views_month", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "filename",    limit: 255
    t.string   "user_hash",   limit: 255
  end

  create_table "meme_slugs", force: :cascade do |t|
    t.integer  "meme_id",    limit: 4
    t.string   "slug",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.boolean  "main",       limit: 1
  end

  add_index "meme_slugs", ["slug"], name: "index_meme_slugs_on_slug", unique: true, using: :btree

  create_table "meme_views", force: :cascade do |t|
    t.string   "user_hash",         limit: 255
    t.integer  "generated_meme_id", limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "memes", force: :cascade do |t|
    t.string   "title",            limit: 255
    t.string   "keywords",         limit: 255
    t.integer  "fame",             limit: 4
    t.integer  "fame_day",         limit: 4
    t.integer  "fame_week",        limit: 4
    t.integer  "fame_month",       limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "image",            limit: 255
    t.string   "img_file_name",    limit: 255
    t.string   "img_content_type", limit: 255
    t.integer  "img_file_size",    limit: 4
    t.datetime "img_updated_at"
  end

  create_table "picdump_categories", force: :cascade do |t|
    t.string   "title",               limit: 255
    t.string   "description",         limit: 255
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "header_file_name",    limit: 255
    t.string   "header_content_type", limit: 255
    t.integer  "header_file_size",    limit: 4
    t.datetime "header_updated_at"
    t.string   "slug",                limit: 255
  end

  add_index "picdump_categories", ["slug"], name: "index_picdump_categories_on_slug", using: :btree

  create_table "picdump_images", force: :cascade do |t|
    t.integer  "picdump_id",          limit: 4
    t.string   "title",               limit: 255
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "img_file_name",       limit: 255
    t.string   "img_content_type",    limit: 255
    t.integer  "img_file_size",       limit: 4
    t.datetime "img_updated_at"
    t.integer  "picdump_category_id", limit: 4
  end

  create_table "picdumps", force: :cascade do |t|
    t.string   "title",               limit: 255
    t.integer  "picdump_category_id", limit: 4
    t.string   "description",         limit: 255
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "slug",                limit: 255
    t.boolean  "visible",             limit: 1
  end

  add_index "picdumps", ["slug"], name: "index_picdumps_on_slug", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.string   "name",                   limit: 255
    t.string   "image",                  limit: 255
    t.boolean  "admin",                  limit: 1
    t.integer  "points",                 limit: 4
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
