# frozen_string_literal: true

class FriendRequestsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: %i[accept reject]
  def create
    @user = User.find(params[:receiver_id])
    current_user.send_friend_request(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    request = FriendRequest.find(params[:id])
    @user = request.receiver
    current_user.retract_friend_request(@user) unless current_user?(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def accept
    friend_request = FriendRequest.find(params[:request_id])
    user = friend_request.sender
    current_user.accept_friend_request(user)

    flash[:success] = Constants::MESSAGES[:friendship_create_success]
    redirect_to user
  end

  def reject
    friend_request = FriendRequest.find(params[:request_id])
    user = friend_request.sender
    current_user.reject_friend_request(user)

    redirect_to received_friend_requests_user_path(current_user)
  end

  private

  def correct_user
    friend_request = FriendRequest.find(params[:request_id])
    return if current_user?(friend_request.receiver)

    flash[:danger] = Constants::MESSAGES[:can_only_answer_requests_for_you]
    redirect_to current_user
  end
end
