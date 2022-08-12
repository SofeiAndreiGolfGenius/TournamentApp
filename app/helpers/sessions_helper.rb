module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    end
  end

  def current_user?(user)
    @current_user == user && !user.nil?
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    if logged_in?
      session.delete(:user_id)
      @current_user = nil
    end
  end
end
