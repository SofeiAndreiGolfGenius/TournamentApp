module UsersHelper
  def team_leader?(user)
    team = Team.find(user.team_id)
    team.leader_id == user.id
  end

  def get_team(user)
    team_id = user.team_id
    team = Team.find(team_id)
  end
end
