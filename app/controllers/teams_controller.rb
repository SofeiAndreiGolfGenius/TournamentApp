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
