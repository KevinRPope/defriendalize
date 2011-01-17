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

ActiveRecord::Schema.define(:version => 20110115061505) do

  create_table "connections", :force => true do |t|
    t.string   "user_facebook_id"
    t.string   "friend_facebook_id"
    t.string   "last_action"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "friend_name"
  end

  create_table "interests", :force => true do |t|
    t.string   "user_facebook_id"
    t.string   "name"
    t.string   "category"
    t.string   "category_facebook_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "current"
  end

  create_table "users", :force => true do |t|
    t.string   "uid"
    t.string   "email"
    t.string   "name"
    t.string   "gender"
    t.string   "birthdate"
    t.string   "interests"
    t.string   "access_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
