# frozen_string_literal: true

module TournamentParticipatingUsersHelper
  def user_already_joined?(tournament, user)
    !TournamentParticipatingUser.where(tournament_id: tournament.id, user_id: user.id).empty?
  end
end
