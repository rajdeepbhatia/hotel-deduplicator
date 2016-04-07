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

ActiveRecord::Schema.define(version: 20160329075847) do

  create_table "cities", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "cleartrip_url", limit: 255
    t.string   "yatra_url",     limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "duplicate_hotel_records", force: :cascade do |t|
    t.integer  "cleartrip_hotel_id", limit: 4
    t.integer  "yatra_hotel_id",     limit: 4
    t.string   "reason",             limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "hotels", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "locality",   limit: 255
    t.string   "source",     limit: 255
    t.string   "url",        limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "city_id",    limit: 4
  end

  create_table "trigrams", force: :cascade do |t|
    t.string  "trigram",     limit: 3
    t.integer "score",       limit: 2
    t.integer "owner_id",    limit: 4
    t.string  "owner_type",  limit: 255
    t.string  "fuzzy_field", limit: 255
  end

  add_index "trigrams", ["owner_id", "owner_type", "fuzzy_field", "trigram", "score"], name: "index_for_match", using: :btree
  add_index "trigrams", ["owner_id", "owner_type"], name: "index_by_owner", using: :btree

end
