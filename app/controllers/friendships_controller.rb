# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user
  def destroy
    Friendship.find(params[:id]).destroy

    flash[:success] = Constants::MESSAGES[:friendship_delete_success]
    redirect_to root_path
  end

  private

  def correct_user
    friendship = Friendship.find(params[:id])
    return if current_user?(friendship.user1) || current_user?(friendship.user2)

    flash[:danger] = Constants::MESSAGES[:can_only_delete_your_friendships]
    redirect_to current_user
  end
end
