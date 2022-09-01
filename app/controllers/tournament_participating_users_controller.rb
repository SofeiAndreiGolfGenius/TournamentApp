# frozen_string_literal: true

class TournamentParticipatingUsersController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :full_tournament, only: [:create]
  before_action :started_tournament, only: [:create]
  def create
    @tournament = Tournament.find(params[:tournament_id])
    current_user.join_tournament(@tournament)
    respond_to do |format|
      format.html { redirect_to @tournament }
      format.js
    end
  end

  def destroy
    @tournament = TournamentParticipatingUser.find(params[:id]).tournament
    current_user.leave_tournament(@tournament)
    respond_to do |format|
      format.html { redirect_to @tournament }
      format.js
    end
  end

  private

  def full_tournament
    tournament = Tournament.find(params[:tournament_id])
    return unless tournament.users.size >= 64 || tournament.teams.size >= 64

    flash[:danger] = 'Sorry, the tournament is full'
    redirect_to(tournament)
  end

  def started_tournament
    tournament = Tournament.find(params[:tournament_id])
    return unless tournament.started?

    flash[:danger] = 'Sorry, the tournament has already started'
    redirect_to(tournament)
  end
end
