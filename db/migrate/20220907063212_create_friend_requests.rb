class CreateFriendRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :friend_requests do |t|
      t.references :receiver, foreign_key: { to_table: :users, on_delete: :cascade }
      t.references :sender, foreign_key: { to_table: :users, on_delete: :cascade }

      t.timestamps
    end
    add_index :friend_requests, %i[receiver_id sender_id], unique: true
  end
end
