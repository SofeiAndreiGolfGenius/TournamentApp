# frozen_string_literal: true

module UsersHelper
  def team_leader?(user)
    team = get_team(user)
    team.leader_id == user.id
  end

  def get_team(user)
    team_id = user.team_id
    Team.find(team_id)
  end

  def same_team?(user1, user2)
    !user1.team_id.nil? and user1.team_id == user2.team_id
  end
end
