# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action :logged_in_user
  before_action :current_team_leader, only: %i[destroy edit update]
  before_action :not_member_of_a_team, only: %i[new create]
  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    @team.leader_id = current_user.id

    if @team.save
      current_user.join_team(@team.id)
      current_user.save
      flash[:success] = 'Team created successfully'
      redirect_to root_path
    else
      render 'new'
    end
  end

  def search
    @team = Team.find_by_name(params[:name])
    if @team.nil?
      flash[:danger] = 'Team not found'
      redirect_to teams_path
    else
      redirect_to @team
    end
  end

  def show
    @team = Team.find(params[:id])
    @leader = User.find(@team.leader_id)
    @members = @team.members.where.not(id: @team.leader_id).paginate(page: params[:page])
    @invitations = @team.team_invitations.where(created_by: 'team').paginate(page: params[:page])
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    if @team.update(team_params)
      flash[:success] = 'Changes saved successfully'
      redirect_to @team
    else
      render 'edit'
    end
  end

  def index
    @teams = Team.all.order(created_at: :desc, id: :desc).paginate(page: params[:page], per_page: 20)
  end

  def invited_to_team
    @team = Team.find(params[:id])
    @invitations = @team.team_invitations.paginate(page: params[:page])
  end

  def destroy
    @team = Team.find(params[:id])

    # put as nil in matches they take part in
    matches = Match.all.where("player1_id = #{@team.id} or player2_id = #{@team.id}", team_sport: true)
    matches.each do |match|
      if match.player1_id == @team.id
        match.update_attribute(:player1_id, nil)
      else
        match.update_attribute(:player2_id, nil)
      end
      match.declare_winner
    end

    @team.destroy!
    flash[:success] = 'Deleted team successfully'
    redirect_to root_path
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end

  def current_team_leader
    team = Team.find(params[:id])
    redirect_to(team) unless team.leader_id == current_user.id
  end

  def not_member_of_a_team
    return if current_user.team_id.nil?

    flash[:danger] = 'You already joined this team'
    team = get_team(current_user)
    redirect_to team
  end
end
