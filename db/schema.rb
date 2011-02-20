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

ActiveRecord::Schema.define(:version => 20110217100415) do

  create_table "connections", :force => true do |t|
    t.string   "user_facebook_id"
    t.string   "friend_facebook_id"
    t.string   "last_action"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "friend_name"
    t.integer  "user_id"
  end

  add_index "connections", ["user_id"], :name => "index_connections_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "educations", :force => true do |t|
    t.integer  "user_id"
    t.string   "level"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "educations", ["user_id"], :name => "index_educations_on_user_id"

  create_table "interests", :force => true do |t|
    t.string   "user_facebook_id"
    t.string   "name"
    t.string   "category"
    t.string   "category_facebook_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "current"
    t.integer  "user_id"
  end

  add_index "interests", ["user_id"], :name => "index_interests_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "uid"
    t.string   "email"
    t.string   "name"
    t.string   "gender"
    t.string   "birthdate"
    t.string   "profile_picture"
    t.string   "access_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
    t.string   "relationship_status"
    t.boolean  "email_me",            :default => true
  end

end
