class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.integer :tournament_id
      t.integer :player1_id
      t.integer :player2_id
      t.integer :player1_score
      t.integer :player2_score
      t.integer :winner_id

      t.timestamps
    end
    add_index :matches, :tournament_id
    add_index :matches, :id
    add_index :matches, %i[tournament_id player1_id player2_id], unique: true
  end
end
