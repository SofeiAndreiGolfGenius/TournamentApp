# frozen_string_literal: true

module UsersHelper
  def team_leader?(user)
    team = get_team(user)
    team.leader_id == user.id
  end

  def get_team(user)
    team_id = user.team_id
    team = Team.find(team_id)
  end
end
