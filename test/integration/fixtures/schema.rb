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

ActiveRecord::Schema.define(:version => 20130222131355) do

  create_table "table1", :force => true do |t|
    t.string   "str"
    t.integer  "int"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "table1", ["id"], :name => "the_index_1", :unique => true
  add_index "table1", ["diesnt_make_sende"], :name => "the_index_2", :unique => true, :wrong_attr => 1

  create_table "table2", :force => true do |t|
    t.date    "date"
    t.integer "max_online",                    :default => 0
  end

  add_index "table2", ["date"], :name => "index_statistics_on_date_and"

  create_table "abc" do |t|
    t.string "defgh"
  end

end
