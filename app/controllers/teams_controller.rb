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

  private

  def team_params
    params.require(:team).permit(:name)
  end
end
