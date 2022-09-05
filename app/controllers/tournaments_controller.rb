# frozen_string_literal: true

class TournamentsController < ApplicationController
  before_action :logged_in_user
  before_action :tournament_organizer, only: %i[start destroy]
  before_action :started_tournament, only: [:start]
  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new(tournament_params)
    @tournament.team_sport = params[:sport] != 'golf'
    @tournament.organizer_id = current_user.id
    if @tournament.save
      flash[:success] = Constants::MESSAGES['TournamentCreateSuccess']
      redirect_to root_path
    else
      render 'new'
    end
  end

  def index
    @filters = []
    Tournament::SPORTS.each do |sport|
      @filters << sport unless params[sport].to_i.zero?
    end
    @filters = Tournament::SPORTS if @filters.empty?
    @tournaments = Tournament.where('sport IN (?)', @filters).order(sport: :asc, created_at: :desc).paginate(
      page: params[:page], per_page: 20
    )
  end

  def show
    @tournament = Tournament.includes(:matches).find(params[:id])
    @participants = take_participants
    return unless @tournament.started?

    if @tournament.winner_id.nil?
      current_round = @tournament.round
      if finished_round?(current_round)
        if current_round == @tournament.nr_of_rounds
          @tournament.update_attribute(:winner_id, @tournament.matches.last.winner_id)
          @message = "Congratulations #{tournament_winner.name} !!!"
        else
          start_next_round(current_round)
        end
      end
    else
      @message = "Congratulations #{tournament_winner.name} !!!"
    end
  end

  def destroy
    @tournament = Tournament.find(params[:id]).destroy
    flash[:success] = Constants::MESSAGES['TournamentDeleteSuccess']
    redirect_to root_path
  end

  def start
    # The tournament should have at least 5 participants
    @tournament = Tournament.find(params[:id])
    if @tournament.users.size < 5 && @tournament.teams.size < 5
      flash[:danger] = Constants::MESSAGES['TournamentNotEnoughPlayers']
    else
      flash[:success] = Constants::MESSAGES['StartTournamentMessage']
      start_tournament
    end
    redirect_to @tournament
  end

  private

  def tournament_organizer
    tournament = Tournament.find(params[:id])
    redirect_to(tournament) unless tournament.organizer_id == current_user.id
  end

  def tournament_params
    params.require(:tournament).permit(:name, :sport)
  end

  def started_tournament
    tournament = Tournament.find(params[:id])
    redirect_to(tournament) if tournament.started?
  end

  def finished_round?(round_number)
    matches = get_matches_from_round(round_number)

    matches.each do |match|
      return false if match.winner_id.nil? && !match.player1_id.nil? && !match.player2_id.nil?
      # bad when there are 2 players and winner_id is null
    end
    true
  end

  def start_next_round(current_round)
    finished_matches = get_matches_from_round(current_round)
    new_matches = get_matches_from_round(current_round + 1)
    (0..new_matches.size - 1).each do |i|
      new_matches[i].update!(player1_id: finished_matches[i * 2].winner_id,
                             player2_id: finished_matches[i * 2 + 1].winner_id)
      new_matches[i].declare_winner if new_matches[i].player1_id.nil? || new_matches[i].player2_id.nil?
    end
    @tournament.update(round: current_round + 1)
  end
end
