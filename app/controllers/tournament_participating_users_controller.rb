# frozen_string_literal: true

class TournamentParticipatingUsersController < ApplicationController
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
end
