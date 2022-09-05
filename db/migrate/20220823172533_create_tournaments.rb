# frozen_string_literal: true

class CreateTournaments < ActiveRecord::Migration[7.0]
  def change
    create_table :tournaments do |t|
      t.string :name
      t.string :sport
      t.boolean :team_sport
      t.integer :round
      t.integer :nr_of_rounds

      t.references :organizer, foreign_key: { to_table: :users, on_delete: :cascade }
      t.integer :winner_id
      t.timestamps
    end
    add_index :tournaments, %i[created_at sport]
  end
end
