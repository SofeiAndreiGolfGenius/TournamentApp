# frozen_string_literal: true

class FriendRequestsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user_receiver, only: %i[accept reject]
  before_action :correct_user_sender, only: [:destroy]
  before_action :friend_request_exists, only: [:create]
  before_action :are_not_friends, only: [:create]
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

  def correct_user_receiver
    friend_request = FriendRequest.find(params[:request_id])
    return if current_user?(friend_request.receiver)

    flash[:danger] = Constants::MESSAGES[:can_only_answer_requests_for_you]
    redirect_to current_user
  end

  def correct_user_sender
    friend_request = FriendRequest.find(params[:id])
    return if current_user?(friend_request.sender)

    flash[:danger] = Constants::MESSAGES[:can_only_retract_your_friend_requests]
    redirect_to current_user
  end

  def friend_request_exists
    user = User.find(params[:receiver_id])
    return if FriendRequest.find_by(sender_id: user.id, receiver_id: current_user.id).nil?

    flash[:danger] = Constants::MESSAGES[:user_already_sent_you_request]
    redirect_to user
  end

  def are_not_friends
    user = User.find(params[:receiver_id])
    return unless current_user.friend?(user)

    flash[:danger] = Constants::MESSAGES[:you_are_already_friends]
    redirect_to user
  end
end
