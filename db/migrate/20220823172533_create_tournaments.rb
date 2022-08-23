class CreateTournaments < ActiveRecord::Migration[7.0]
  def change
    create_table :tournaments do |t|
      t.string :name
      t.string :sport
      t.references :organizer, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :tournaments, [:created_at, :sport]
  end
end
