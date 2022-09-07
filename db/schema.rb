# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_09_07_063439) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friend_requests", force: :cascade do |t|
    t.bigint "receiver_id"
    t.bigint "sender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id", "sender_id"], name: "index_friend_requests_on_receiver_id_and_sender_id", unique: true
    t.index ["receiver_id"], name: "index_friend_requests_on_receiver_id"
    t.index ["sender_id"], name: "index_friend_requests_on_sender_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.bigint "user1_id"
    t.bigint "user2_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user1_id", "user2_id"], name: "index_friendships_on_user1_id_and_user2_id", unique: true
    t.index ["user1_id"], name: "index_friendships_on_user1_id"
    t.index ["user2_id"], name: "index_friendships_on_user2_id"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "tournament_id"
    t.integer "player1_id"
    t.integer "player2_id"
    t.integer "in_round"
    t.integer "player1_score"
    t.integer "player2_score"
    t.integer "winner_id"
    t.string "sport"
    t.boolean "team_sport"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_id", "player1_id", "player2_id"], name: "index_matches_on_tournament_id_and_player1_id_and_player2_id", unique: true
    t.index ["tournament_id"], name: "index_matches_on_tournament_id"
  end

  create_table "team_invitations", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "user_id"
    t.string "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id", "user_id"], name: "index_team_invitations_on_team_id_and_user_id", unique: true
    t.index ["team_id"], name: "index_team_invitations_on_team_id"
    t.index ["user_id"], name: "index_team_invitations_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.bigint "leader_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["leader_id"], name: "index_teams_on_leader_id"
  end

  create_table "tournament_participating_teams", force: :cascade do |t|
    t.bigint "tournament_id"
    t.bigint "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_tournament_participating_teams_on_team_id"
    t.index ["tournament_id", "team_id"], name: "index_participating_teams_to_not_be_duplicates", unique: true
    t.index ["tournament_id"], name: "index_tournament_participating_teams_on_tournament_id"
  end

  create_table "tournament_participating_users", force: :cascade do |t|
    t.bigint "tournament_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_id", "user_id"], name: "index_participating_users_to_not_be_duplicates", unique: true
    t.index ["tournament_id"], name: "index_tournament_participating_users_on_tournament_id"
    t.index ["user_id"], name: "index_tournament_participating_users_on_user_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "name"
    t.string "sport"
    t.boolean "team_sport"
    t.integer "round"
    t.integer "nr_of_rounds"
    t.bigint "organizer_id"
    t.integer "winner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "started", default: false
    t.index ["created_at", "sport"], name: "index_tournaments_on_created_at_and_sport"
    t.index ["organizer_id"], name: "index_tournaments_on_organizer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.boolean "admin", default: false
    t.bigint "team_id"
    t.index ["team_id"], name: "index_users_on_team_id"
  end

  add_foreign_key "friend_requests", "users", column: "receiver_id", on_delete: :cascade
  add_foreign_key "friend_requests", "users", column: "sender_id", on_delete: :cascade
  add_foreign_key "friendships", "users", column: "user1_id", on_delete: :cascade
  add_foreign_key "friendships", "users", column: "user2_id", on_delete: :cascade
  add_foreign_key "matches", "tournaments", on_delete: :cascade
  add_foreign_key "team_invitations", "teams", on_delete: :cascade
  add_foreign_key "team_invitations", "users", on_delete: :cascade
  add_foreign_key "teams", "users", column: "leader_id"
  add_foreign_key "tournament_participating_teams", "teams", on_delete: :cascade
  add_foreign_key "tournament_participating_teams", "tournaments", on_delete: :cascade
  add_foreign_key "tournament_participating_users", "tournaments", on_delete: :cascade
  add_foreign_key "tournament_participating_users", "users", on_delete: :cascade
  add_foreign_key "tournaments", "users", column: "organizer_id", on_delete: :cascade
  add_foreign_key "users", "teams"
end
