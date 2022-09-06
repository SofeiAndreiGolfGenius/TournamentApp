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

  def make_player_nil(player, is_team)
    matches = Match.all.where("player1_id = #{player.id} or player2_id = #{player.id}", team_sport: is_team)
    matches.each do |match|
      if match.player1_id == player.id
        match.update_attribute(:player1_id, nil)
      else
        match.update_attribute(:player2_id, nil)
      end
      match.declare_winner if match.winner_id.nil?
    end
  end
end
