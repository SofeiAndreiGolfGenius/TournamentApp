# frozen_string_literal: true

class TournamentParticipatingTeam < ApplicationRecord
  belongs_to :tournament
  belongs_to :team
  validates :tournament_id, presence: true
  validates :team_id, presence: true
end
