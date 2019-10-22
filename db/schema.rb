# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_21_225509) do

  create_table "blackjacks", force: :cascade do |t|
    t.string "dealer_cards"
    t.string "player_cards"
    t.integer "dealer_card_total"
    t.integer "player_card_total"
    t.string "next_card"
  end

  create_table "results", force: :cascade do |t|
    t.integer "user_id"
    t.integer "blackjack_id"
    t.integer "pot"
    t.index ["blackjack_id"], name: "index_results_on_blackjack_id"
    t.index ["user_id"], name: "index_results_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "user_name"
    t.integer "balance"
  end

  add_foreign_key "results", "blackjacks"
  add_foreign_key "results", "users"
end
