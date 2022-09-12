# frozen_string_literal: true

class MatchesController < ApplicationController
  before_action :logged_in_user
  before_action :tournament_organizer, only: %i[declare_winner reset_score]
  before_action :match_participant_or_organizer, only: [:update]
  before_action :score_already_declared, only: %i[update]

  def update
    @match = Match.includes(:tournament).find(params[:id])
    tournament = @match.tournament
    if @match.update(match_params)
      message = Constants::MESSAGES[:score_success_by_user]
      if tournament_organizer?(tournament, current_user)
        message = Constants::MESSAGES[:score_success_by_organizer]
        declare_winner
        flash[:success] = message
      else
        flash[:success] = message
        redirect_to tournament
      end
    else
      flash[:danger] = Constants::MESSAGES[:match_draw]
      redirect_to tournament
    end
  end

  def declare_winner
    @match = Match.includes(:tournament).find(params[:id])
    @match.declare_winner
    redirect_to @match.tournament
  end

  def reset_score
    @match = Match.includes(:tournament).find(params[:id])
    @match.update!(player1_score: nil,
                   player2_score: nil)
    redirect_to @match.tournament
  end

  private

  def match_params
    params.require(:match).permit(:player1_score, :player2_score)
  end

  def tournament_organizer
    match = Match.includes(:tournament).find(params[:id])
    tournament = match.tournament
    redirect_to(tournament) unless tournament.organizer_id == current_user.id
  end

  def match_participant_or_organizer
    match = Match.includes(:tournament).find(params[:id])
    tournament = match.tournament
    redirect_to(tournament) unless tournament.organizer_id == current_user.id ||
                                   participated_in_match?(current_user, match)
  end

  def score_already_declared
    match = Match.find(params[:id])
    return if match.player1_score.nil? && match.player2_score.nil?

    tournament = match.tournament
    flash[:danger] = Constants::MESSAGES[:score_declared]
    redirect_to(tournament)
  end
end
