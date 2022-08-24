# frozen_string_literal: true

class TournamentParticipatingUser < ApplicationRecord
  belongs_to :tournament
  belongs_to :user
  validates :tournament_id, presence: true
  validates :user_id, presence: true
end
