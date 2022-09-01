class MatchesController < ApplicationController
  before_action :logged_in_user
  before_action :tournament_organizer, only: %i[declare_winner reset_score]
  before_action :match_participant_or_organizer, only: [:update]
  before_action :score_already_declared, only: [:update]
  def update
    @match = Match.find(params[:id])
    tournament = @match.tournament
    if @match.update(match_params)
      message1 = 'Score declared successfully'
      message2 = tournament_organizer?(tournament, current_user) ? '' : ', waiting for tournament organizer to approve'
      flash[:success] = message1 + message2
      if tournament_organizer?(tournament, current_user)
        declare_winner
      else
        redirect_to tournament
      end
    else
      flash[:danger] = 'Can not be a draw!'
      redirect_to tournament
    end
  end

  def declare_winner
    @match = Match.find(params[:id])
    if @match.player2_id.nil? && !@match.player1_id.nil?
      @match.update_attribute(:winner_id, @match.player1_id)
    else
      tournament = @match.tournament
      if tournament.sport == 'golf'
        winner_id = @match.player1_score < @match.player2_score ? @match.player1_id : @match.player2_id
      else
        winner_id = @match.player1_score > @match.player2_score ? @match.player1_id : @match.player2_id
      end
      @match.update_attribute(:winner_id, winner_id)
      respond_to do |format|
        format.html { redirect_to tournament }
        format.js
      end
    end
  end

  def reset_score
    @match = Match.find(params[:id])
    @match.update!(player1_score: nil,
                   player2_score: nil)
    redirect_to @match.tournament
  end

  private

  def match_params
    params.require(:match).permit(:player1_score, :player2_score)
  end

  def tournament_organizer
    match = Match.find(params[:id])
    tournament = match.tournament
    redirect_to(tournament) unless tournament.organizer_id == current_user.id
  end

  def match_participant_or_organizer
    match = Match.find(params[:id])
    tournament = match.tournament
    redirect_to(tournament) unless tournament.organizer_id == current_user.id ||
                                   participated_in_match?(current_user, match)
  end

  def score_already_declared
    match = Match.find(params[:id])
    tournament = match.tournament
    unless match.player1_score.nil? && match.player2_score.nil?
      flash[:danger] = 'Score has already been declared'
      redirect_to(tournament)
    end
  end
end