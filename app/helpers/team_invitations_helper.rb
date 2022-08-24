# frozen_string_literal: true

module TeamInvitationsHelper
  def already_invited?(user, team)
    !TeamInvitation.where(user_id: user.id, team_id: team.id).empty?
  end
end
