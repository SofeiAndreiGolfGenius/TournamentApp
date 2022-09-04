# frozen_string_literal: true

class CreateTournamentParticipatingUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :tournament_participating_users do |t|
      t.integer :tournament_id
      t.integer :user_id

      t.timestamps
    end
    add_index :tournament_participating_users, :tournament_id
    add_index :tournament_participating_users, :user_id
    add_index :tournament_participating_users, %i[tournament_id user_id],
              unique: true,
              name: 'index_participating_users_to_not_be_duplicates'
  end
end
