# frozen_string_literal: true

class UsersController < ApplicationController
  require 'will_paginate/array'
  before_action :logged_in_user,
                only: %i[edit update destroy team_invitations show index leave_team kick_out_of_team
                         received_friend_requests friends]
  before_action :admin_or_current_user, only: [:destroy]
  before_action :correct_user, only: %i[edit update received_friend_requests friends]
  before_action :same_team, only: [:kick_out_of_team]
  before_action :team_leader, only: [:kick_out_of_team]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = Constants::MESSAGES[:user_create_success]
      redirect_to @user
    else
      render 'new'
    end
  end

  def search
    @user = User.find_by_name(params[:name])
    if @user.nil?
      flash[:danger] = Constants::MESSAGES[:user_not_found]
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
      flash[:success] = Constants::MESSAGES[:update_success]
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    make_player_nil(@user, false)

    unless @user.team_id.nil?
      team = Team.find(@user.team_id)
      if team.leader_id == @user.id
        if team.members.size > 1
          team.update_attribute(:leader_id, team.members[1].id)
        else
          make_player_nil(team, true)
          team.destroy!
        end
      end
    end

    log_out if @user.id == current_user.id
    @user.destroy!
    flash[:success] = Constants::MESSAGES[:user_delete_success]
    redirect_to root_path
  end

  def index
    @users = User.all.order(created_at: :desc, id: :desc).paginate(page: params[:page], per_page: 20)
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

  def received_friend_requests
    @user = User.find(params[:id])
    @friend_requests = @user.received_friend_requests.paginate(page: params[:page], per_page: 20)
  end

  def friends
    @user = User.find(params[:id])
    @friends = @user.friends.paginate(page: params[:page], per_page: 20)
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
    return if current_user.id == team.leader_id

    flash[:danger] = Constants::MESSAGES[:not_team_leader]
    redirect_to(user)
  end

  def same_team
    user = User.find(params[:id])
    redirect_to(user) unless same_team?(current_user, user)
  end

  def admin_or_current_user
    user = User.find(params[:id])
    redirect_to(root_url) unless current_user.admin? || current_user.id == user.id
  end
end
