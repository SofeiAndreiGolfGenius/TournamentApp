class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.references :friendship, foreign_key: { on_delete: :cascade }
      t.text :content
      t.integer :sender_id
      t.integer :receiver_id

      t.timestamps
    end
    add_index :messages, [:created_at]
  end
end
