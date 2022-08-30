module MatchesHelper
  def participated_in_match?(user, match)
    team = get_team(user)
    user.id == match.player1_id || user.id == match.player2_id ||
      team.id == match.player1_id || team.id == match.player2_id
  end
end
