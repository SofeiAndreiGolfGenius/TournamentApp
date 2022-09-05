# frozen_string_literal: true

class CreateTournamentParticipatingUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :tournament_participating_users do |t|
      t.references :tournament, foreign_key: { to_table: :tournaments, on_delete: :cascade }
      t.references :user, foreign_key: { to_table: :users, on_delete: :cascade }

      t.timestamps
    end
    add_index :tournament_participating_users, %i[tournament_id user_id],
              unique: true,
              name: 'index_participating_users_to_not_be_duplicates'
  end
end
