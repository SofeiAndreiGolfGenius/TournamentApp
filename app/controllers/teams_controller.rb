# frozen_string_literal: true

class TeamsController < ApplicationController
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

  def show
    @team = Team.find(params[:id])
    @leader = User.find(@team.leader_id)
    @members = @team.members.where.not(id: @team.leader_id).paginate(page: params[:page])
    @invitations = @team.team_invitations.where(created_by: 'team').paginate(page: params[:page])
  end

  def index
    @teams = Team.all.order(created_at: :desc, id: :desc).paginate(page: params[:page], per_page: 10)
  end

  def invited_to_team
    @team = Team.find(params[:id])
    @invitations = @team.team_invitations.paginate(page: params[:page])
  end

  def destroy
    @team = Team.find(params[:id]).destroy
    flash[:success] = 'Deleted team successfully'
    redirect_to root_path
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end
end
