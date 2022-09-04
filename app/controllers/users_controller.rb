# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[edit update destroy team_invitations show index]
  before_action :admin_user_or_current, only: [:destroy]
  before_action :correct_user, only: %i[edit update]
  before_action :same_team, only: [:kick_out_of_team]
  before_action :team_leader, only: [:kick_out_of_team]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'User registered successfully'
      redirect_to @user
    else
      render 'new'
    end
  end

  def search
    @user = User.find_by_name(params[:name])
    if @user.nil?
      flash[:danger] = 'User not found'
      redirect_to users_path
    else
      redirect_to @user
    end
  end

  def show
    @user = User.find(params[:id])
    if @user.team_id.nil?
      @invitations = @user.team_invitations.where(created_by: 'user').paginate(page: params[:page])
    else
      @team = Team.find(@user.team_id)
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'Changes saved successfully'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])

    matches = Match.all.where("player1_id = #{@user.id} or player2_id = #{@user.id}", team_sport: false)
    matches.each do |match|
      if match.player1_id == @user.id
        match.update_attribute(:player1_id, nil)
      else
        match.update_attribute(:player2_id, nil)
      end
      match.declare_winner
    end

    unless @user.team_id.nil?
      team = Team.includes(:members).find(@user.team_id)
      if team.leader_id == @user.id
        if team.members.size > 1
          team.update_attribute(:leader_id, team.members[1].id)
        else
          matches = Match.all.where("player1_id = #{team.id} or player2_id = #{team.id}", team_sport: true)
          matches.each do |match|
            if match.player1_id == team.id
              match.update_attribute(:player1_id, nil)
            else
              match.update_attribute(:player2_id, nil)
            end
            match.declare_winner
          end
          team.destroy!
        end
      end
    end

    if @user.id == current_user.id
      log_out
    end
    @user.destroy!
    flash[:success] = 'Deleted user successfully'
    redirect_to root_path
  end

  def index
    @users = User.all.order(created_at: :desc, id: :desc).paginate(page: params[:page], per_page: 20)
  end

  def join_team
    @team = Team.find(params[:team_id])
    current_user.join_team(@team.id)
    current_user.save
    redirect_to current_user
  end

  def leave_team
    current_user.update_attribute(:team_id, nil)
    redirect_to current_user
  end

  def kick_out_of_team
    user = User.find(params[:id])
    team = get_team(user)
    user.update_attribute(:team_id, nil)
    redirect_to team
  end

  def team_invitations
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def team_leader
    user = User.find(params[:id])
    team = get_team(user)
    redirect_to(user) unless current_user.id == team.leader_id
  end

  def same_team
    user = User.find(params[:id])
    redirect_to(user) unless same_team?(current_user, user)
  end

  def admin_user_or_current
    user = User.find(params[:id])
    redirect_to(root_url) unless current_user.admin? || current_user.id == user.id
  end
end
