# frozen_string_literal: true

class TournamentParticipatingTeamsController < ApplicationController
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
end
