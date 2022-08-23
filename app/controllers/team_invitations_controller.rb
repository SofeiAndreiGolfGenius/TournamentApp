class TeamInvitationsController < ApplicationController
  def ask_to_join
    @team = Team.find(params[:id])
    current_user.ask_to_join(@team)
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
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def accept_invitation
    team = Team.find(params[:team_id])
    current_user.accept_invitation(team)
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

end