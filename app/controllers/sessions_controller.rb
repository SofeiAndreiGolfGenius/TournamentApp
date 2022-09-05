# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in user
      flash[:success] = Constants::MESSAGES['LoginSuccess'] + user.name
      redirect_to user_path(user)
    else
      flash[:danger] = Constants::MESSAGES['LoginFail']
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
