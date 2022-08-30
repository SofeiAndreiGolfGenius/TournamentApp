# frozen_string_literal: true

class CreateTournamentParticipatingTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :tournament_participating_teams do |t|
      t.integer :tournament_id
      t.integer :team_id
      t.boolean :eliminated, default: false
      t.timestamps
    end
    add_index :tournament_participating_teams, :tournament_id
    add_index :tournament_participating_teams, :team_id
    add_index :tournament_participating_teams, %i[tournament_id team_id],
              unique: true, name: 'index_participating_teams_to_not_be_duplicates'
  end
end
