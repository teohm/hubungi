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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110904075800) do

  create_table "accounts", :force => true do |t|
    t.string   "provider"
    t.string   "identifier"
    t.string   "display_name"
    t.string   "auth_type"
    t.string   "auth_token1"
    t.string   "auth_token2"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["profile_id"], :name => "index_accounts_on_profile_id"

  create_table "profiles", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
