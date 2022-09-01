# frozen_string_literal: true

module MatchesHelper
  def participated_in_match?(user, match)
    if !user.team_id.nil?
      team = get_team(user)
      user.id == match.player1_id || user.id == match.player2_id ||
        team.id == match.player1_id || team.id == match.player2_id
    else
      user.id == match.player1_id || user.id == match.player2_id
    end
  end
end
