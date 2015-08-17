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

ActiveRecord::Schema.define(version: 20150726123902) do

  create_table "event_types", force: true do |t|
    t.string   "name"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_workgroups", force: true do |t|
    t.integer  "event_id"
    t.integer  "workgroup_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "title"
    t.text     "comment"
    t.datetime "datetime"
    t.integer  "user_id"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "week"
    t.string   "file"
    t.string   "dot_color"
    t.string   "ring_name"
    t.integer  "type_id"
  end

  add_index "events", ["school_id"], name: "index_events_on_school_id"
  add_index "events", ["user_id"], name: "index_events_on_user_id"

  create_table "high_lights", force: true do |t|
    t.integer  "week"
    t.integer  "year"
    t.integer  "color"
    t.text     "comment"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "high_lights", ["user_id"], name: "index_high_lights_on_user_id"

  create_table "school_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "school_users", ["school_id"], name: "index_school_users_on_school_id"
  add_index "school_users", ["user_id"], name: "index_school_users_on_user_id"

  create_table "schools", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "district"
    t.string   "file"
  end

  create_table "user_workgroups", force: true do |t|
    t.integer  "user_id"
    t.integer  "workgroup_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "user_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid"
    t.string   "provider"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
  end

  create_table "workgroups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

end
