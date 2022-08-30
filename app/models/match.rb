class Match < ApplicationRecord
  belongs_to :tournament
  belongs_to :player1, class_name: 'User', optional: true
  belongs_to :player2, class_name: 'User', optional: true

  validates :tournament_id, presence: true
  validates_with ValidScoreValidator

  def round_where_match_is
    nr_rounds = tournament.nr_of_rounds
    (1..nr_rounds).each do |i|
      matches = get_matches_from_round(i)
      return i if matches.include? self
    end
  end
end
