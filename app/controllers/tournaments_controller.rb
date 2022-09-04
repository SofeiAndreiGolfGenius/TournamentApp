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
      flash[:success] = 'Tournament created successfully'
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
    @tournaments = Tournament.where('sport IN (?)', @filters).order(sport: :asc, created_at: :desc).paginate(page: params[:page], per_page: 20)
  end

  def show
    @tournament = Tournament.includes(:matches).find(params[:id])
    if @tournament.sport == 'golf'
      @paticipating_users = @tournament.users.paginate(page: params[:page])
    else
      @paticipating_teams = @tournament.teams.paginate(page: params[:page])
    end
    return unless @tournament.started?

    if @tournament.winner_id.nil?
      last_match = @tournament.matches.last
      @tournament.update_attribute(:winner_id, last_match.winner_id) unless last_match.winner_id.nil?
    end

    if @tournament.winner_id.nil?
      current_round = @tournament.round
      if finished_round?(current_round)
        start_next_round(current_round)
        @tournament.update(round: current_round + 1)
      end
    end
    unless @tournament.winner_id.nil?
      winner = if !@tournament.team_sport?
                 User.find(@tournament.matches.last.winner_id)
               else
                 Team.find(@tournament.matches.last.winner_id)
               end
      @message = "Congratulations #{winner.name} !!!"
    end
  end

  def destroy
    @tournament = Tournament.find(params[:id]).destroy
    flash[:success] = 'Deleted tournament successfully'
    redirect_to root_path
  end

  def start
    # The tournament should have at least 5 participants
    @tournament = Tournament.find(params[:id])
    if @tournament.users.size < 5 && @tournament.teams.size < 5
      flash[:danger] = 'Not enough participants to start the tournament'
    else
      flash[:success] = 'Tournament started, good luck everyone!'
      @tournament.update(started: true, round: 1, nr_of_rounds: nr_of_rounds)
      initialize_matches
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

  def start_next_round(current_round_number)
    finished_matches = get_matches_from_round(current_round_number)
    new_matches = get_matches_from_round(current_round_number + 1)
    (0..new_matches.size - 1).each do |i|
      new_matches[i].update!(player1_id: finished_matches[i * 2].winner_id,
                             player2_id: finished_matches[i * 2 + 1].winner_id)
      new_matches[i].declare_winner if new_matches[i].player1_id.nil? || new_matches[i].player2_id.nil?
    end
  end
end
