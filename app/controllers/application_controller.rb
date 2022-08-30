# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  include TeamInvitationsHelper
  include UsersHelper
  include TournamentParticipatingTeamsHelper
  include TournamentParticipatingUsersHelper
  include TournamentsHelper
  include MatchesHelper
  def logged_in_user
    unless logged_in?
      flash[:danger] = 'Please log in'
      redirect_to login_url
    end
  end
end
