# frozen_string_literal: true

class CreateTournamentParticipatingTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :tournament_participating_teams do |t|
      t.references :tournament, foreign_key: { to_table: :tournaments, on_delete: :cascade }
      t.references :team, foreign_key: { to_table: :teams, on_delete: :cascade }

      t.timestamps
    end
    add_index :tournament_participating_teams, %i[tournament_id team_id],
              unique: true, name: 'index_participating_teams_to_not_be_duplicates'
  end
end
