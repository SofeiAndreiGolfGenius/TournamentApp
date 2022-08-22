class AddTeamToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :team, foreign_key: true, on_delete: :nullify
  end
end
