class CreateFriendships < ActiveRecord::Migration[7.0]
  def change
    create_table :friendships do |t|
      t.references :user1, foreign_key: { to_table: :users, on_delete: :cascade }
      t.references :user2, foreign_key: { to_table: :users, on_delete: :cascade }

      t.timestamps
    end
    add_index :friendships, %i[user1_id user2_id], unique: true
  end
end
