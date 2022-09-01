# frozen_string_literal: true

class TeamInvitationsController < ApplicationController
  before_action :logged_in_user
  before_action :team_member, only: %i[approve_invitation deny_invitation]
  before_action :already_joined_your_team, only: %i[approve_invitation deny_invitation]
  before_action :already_joined_another_team, only: %i[approve_invitation deny_invitation]
  before_action :you_already_joined_a_team, only: %i[accept_invitation reject_invitation]
  def ask_to_join
    @team = Team.find(params[:id])
    current_user.ask_to_join(@team)
    flash[:success] = 'Request sent, wait for a team member to accept you'
    respond_to do |format|
      format.html { redirect_to @team }
      format.js
    end
  end

  def invite_to
    @user = User.find(params[:id])
    team_id = current_user.team_id
    team = Team.find(team_id)
    team.invite_to_team(@user)
    flash[:success] = 'Invite sent, wait for the user to respond'
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def accept_invitation
    team = Team.find(params[:team_id])
    current_user.accept_invitation(team)
    flash[:success] = "Invite accepted, welcome to #{team.name}"
    respond_to do |format|
      format.html { redirect_to current_user }
      format.js
    end
    # the current user has to join the team and also reject all other invitations
  end

  def reject_invitation
    team = Team.find(params[:team_id])
    current_user.decline_invitation(team)
    respond_to do |format|
      format.html { redirect_to current_user }
      format.js
    end
    # the invite must be deleted
  end

  def approve_invitation
    @team = Team.find(params[:id])
    user = User.find(params[:user_id])
    @team.approve_invitation(user)
    flash[:success] = "Request approved, #{user.name} was added to your team"
    respond_to do |format|
      format.html { redirect_to @team }
      format.js
    end
    # the user has to join the current team and also delete his other invitations
  end

  def deny_invitation
    @team = Team.find(params[:id])
    user = User.find(params[:user_id])
    @team.deny_invitation(user)
    respond_to do |format|
      format.html { redirect_to @team }
      format.js
    end
    # the invite must be deleted
  end

  def destroy
    # the invite must be deleted
  end

  private

  def team_member
    team = Team.find(params[:id])
    redirect_to(team) unless team == get_team(current_user)
  end

  def already_joined_your_team
    user = User.find(params[:user_id])
    if user.team_id == current_user.id
      flash[:success] = 'User already joined your team'
      redirect_to(get_team(user))
    end
  end

  def already_joined_another_team
    user = User.find(params[:user_id])
    unless user.team_id.nil?
      flash[:danger] = 'User already joined another team'
      redirect_to(user)
    end
  end

  def you_already_joined_a_team
    user = User.find(params[:id])
    unless user.team_id.nil?
      flash[:danger] = 'You already joined this team'
      redirect_to(get_team(user))
    end
  end
end
