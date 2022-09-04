# frozen_string_literal: true

class Match < ApplicationRecord
  belongs_to :tournament

  validates :tournament_id, presence: true
  validates_with ValidScoreValidator

  def round_where_match_is
    nr_rounds = tournament.nr_of_rounds
    (1..nr_rounds).each do |i|
      matches = get_matches_from_round(i)
      return i if matches.include? self
    end
  end

  def get_player(player_id)
    tournament.sport == 'golf' ? User.find(player_id) : Team.find(player_id)
  end

  def declare_winner
    winner_id = if player1_id.nil?
                  player2_id
                elsif player2_id.nil?
                  player1_id
                elsif sport == 'golf'
                  player1_score < player2_score ? player1_id : player2_id
                else
                  player1_score > player2_score ? player1_id : player2_id
                end
    update_attribute(:winner_id, winner_id)
  end
end
