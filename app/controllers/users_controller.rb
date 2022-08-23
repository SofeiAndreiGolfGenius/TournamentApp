class UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update]
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
    @user = User.find(params[:id]).destroy
    flash[:success] = 'Deleted user successfully'
    redirect_to root_path
  end

  def index
    @users = User.all.order(created_at: :desc, id: :desc).paginate(page: params[:page], per_page: 10)
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
    team = Team.find(user.team_id)
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

end
