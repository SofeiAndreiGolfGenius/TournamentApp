# frozen_string_literal: true

class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.references :tournament, foreign_key: { to_table: :tournaments, on_delete: :cascade }
      t.integer :player1_id
      t.integer :player2_id
      t.integer :player1_score
      t.integer :player2_score
      t.integer :winner_id

      t.string :sport
      t.boolean :team_sport

      t.timestamps
    end
    add_index :matches, %i[tournament_id player1_id player2_id], unique: true
  end
end
