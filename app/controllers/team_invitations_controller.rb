# frozen_string_literal: true

class TeamInvitationsController < ApplicationController
  before_action :logged_in_user
  before_action :team_member, only: %i[approve_invitation deny_invitation]
  before_action :already_joined_your_team, only: %i[approve_invitation deny_invitation]
  before_action :already_joined_another_team, only: %i[approve_invitation deny_invitation]
  before_action :you_already_joined_a_team, only: %i[accept_invitation reject_invitation]
  before_action :you_have_a_team, only: [:invite_to]
  before_action :user_does_not_have_a_team, only: [:invite_to]
  before_action :you_do_not_have_a_team, only: [:ask_to_join]
  def ask_to_join
    @team = Team.find(params[:id])
    current_user.ask_to_join(@team)
    flash[:success] = Constants::MESSAGES[:join_request_sent]
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
    flash[:success] = Constants::MESSAGES[:invite_sent]
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
    return unless user.team_id == current_user.id

    flash[:success] = Constants::MESSAGES[:user_already_joined_your_team]
    redirect_to(get_team(user))
  end

  def already_joined_another_team
    user = User.find(params[:user_id])
    return if user.team_id.nil?

    flash[:danger] = Constants::MESSAGES[:user_already_joined_another_team]
    redirect_to(user)
  end

  def you_already_joined_a_team
    user = User.find(params[:id])
    return if user.team_id.nil?

    flash[:danger] = Constants::MESSAGES[:you_already_joined]
    redirect_to(get_team(user))
  end

  def you_have_a_team
    return unless current_user.team_id.nil?

    flash[:danger] = Constants::MESSAGES[:you_do_not_have_a_team]
    redirect_to current_user
  end

  def you_do_not_have_a_team
    return if current_user.team_id.nil?

    flash[:danger] = Constants::MESSAGES[:you_already_have_a_team]
    redirect_to current_user
  end

  def user_does_not_have_a_team
    user = User.find(params[:id])
    return if user.team_id.nil?

    flash[:danger] = Constants::MESSAGES[:user_already_has_a_team]
    redirect_to user
  end
end
