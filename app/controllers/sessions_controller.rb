# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in user
      flash[:success] = "Logged in as #{user.name}"
      redirect_to user_path(user)
    else
      flash[:danger] = 'Wrong password or email'
      render 'new'
    end
  end

  def destroy
    puts 'not yet'
    if logged_in?
      puts 'Yes, logged in'
      log_out
    end
    redirect_to root_path
  end
end
