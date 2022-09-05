# frozen_string_literal: true

class CreateTeamInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :team_invitations do |t|
      t.references :team, foreign_key: { to_table: :teams, on_delete: :cascade }
      t.references :user, foreign_key: { to_table: :users, on_delete: :cascade }
      t.string :created_by

      t.timestamps
    end
    add_index :team_invitations, %i[team_id user_id], unique: true
  end
end
