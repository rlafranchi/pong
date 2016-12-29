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

ActiveRecord::Schema.define(version: 20161229040917) do

  create_table "games", force: :cascade do |t|
    t.integer "status", default: 0
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
  end

  create_table "players_games", force: :cascade do |t|
    t.integer "game_id"
    t.integer "player_id"
    t.integer "position"
    t.integer "score",     limit: 1, default: 0
  end

end
