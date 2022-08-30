class MatchesController < ApplicationController
  def update
    @match = Match.find(params[:id])
    tournament = Tournament.find(@match.tournament_id)
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
      tournament = Tournament.find(@match.tournament_id)
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

  private

  def match_params
    params.require(:match).permit(:player1_score, :player2_score)
  end
end
