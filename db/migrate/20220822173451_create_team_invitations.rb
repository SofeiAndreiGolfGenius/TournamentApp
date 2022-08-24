# frozen_string_literal: true

class CreateTeamInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :team_invitations do |t|
      t.integer :team_id
      t.integer :user_id
      t.string :created_by

      t.timestamps
    end
    add_index :team_invitations, :team_id
    add_index :team_invitations, :user_id
    add_index :team_invitations, %i[team_id user_id], unique: true
  end
end
