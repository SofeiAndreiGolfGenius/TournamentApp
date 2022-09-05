# frozen_string_literal: true

class TournamentParticipatingTeamsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :full_tournament, only: [:create]
  before_action :started_tournament, only: [:create]
  before_action :check_team_leader
  def create
    @tournament = Tournament.find(params[:tournament_id])
    get_team(current_user).join_tournament(@tournament)
    respond_to do |format|
      format.html { redirect_to @tournament }
      format.js
    end
  end

  def destroy
    @tournament = TournamentParticipatingTeam.find(params[:id]).tournament
    get_team(current_user).leave_tournament(@tournament)
    respond_to do |format|
      format.html { redirect_to @tournament }
      format.js
    end
  end

  private

  def full_tournament
    tournament = Tournament.find(params[:tournament_id])
    return unless tournament.teams.size >= 32

    flash[:danger] = Constants::MESSAGES['TournamentFull']
    redirect_to(tournament)
  end

  def started_tournament
    tournament = Tournament.find(params[:tournament_id])
    return unless tournament.started?

    flash[:danger] = Constants::MESSAGES['TournamentStarted']
    redirect_to(tournament)
  end

  def check_team_leader
    return if team_leader?(current_user)

    flash[:danger] = Constants::MESSAGES['NotTeamLeader']
    redirect_to(tournament)
  end
end
