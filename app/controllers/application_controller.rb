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
    return if logged_in?

    flash[:danger] = Constants::MESSAGES[:not_logged_in]
    redirect_to login_url
  end
end
