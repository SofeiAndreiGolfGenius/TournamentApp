# frozen_string_literal: true

module TournamentParticipatingTeamsHelper
  def team_already_joined?(tournament, team)
    !TournamentParticipatingTeam.where(tournament_id: tournament.id, team_id: team.id).empty?
  end
end
