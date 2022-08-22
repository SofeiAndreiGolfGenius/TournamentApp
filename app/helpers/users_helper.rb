module UsersHelper
  def team_leader?(user)
    team = Team.find(user.team_id)
    team.leader_id == user.id
  end
end
