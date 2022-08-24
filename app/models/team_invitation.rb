# frozen_string_literal: true

class TeamInvitation < ApplicationRecord
  belongs_to :team
  belongs_to :user
  validates :team_id, presence: true
  validates :user_id, presence: true
end
