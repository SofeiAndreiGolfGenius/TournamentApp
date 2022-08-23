class TournamentsController < ApplicationController

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new(tournament_params)
    @tournament.organizer_id = current_user.id
    if @tournament.save
      flash[:success] = 'Tournament created successfully'
      redirect_to root_path
    else
      render 'new'
    end
  end

  def index
    @tournaments = Tournament.all.order(sport: :asc, created_at: :desc).paginate(page: params[:page], per_page: 10)
  end

  def show
    @tournament = Tournament.find(params[:id])
  end

  def destroy
    @tournament = Tournament.find(params[:id]).destroy
    flash[:success] = 'Deleted tournament successfully'
    redirect_to root_path
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name, :sport)
  end
end
