# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user
  after_action :read_messages, only: [:chatroom]
  def destroy
    Friendship.find(params[:id]).destroy

    flash[:success] = Constants::MESSAGES[:friendship_delete_success]
    redirect_to root_path
  end

  def chatroom
    @friendship = Friendship.includes(:messages).find(params[:id])
    @me = current_user
    @friend = if current_user?(@friendship.user1)
                @friendship.user2
              else
                @friendship.user1
              end
    @messages = @friendship.messages
  end

  private

  def correct_user
    friendship = Friendship.find(params[:id])
    return if current_user?(friendship.user1) || current_user?(friendship.user2)

    flash[:danger] = Constants::MESSAGES[:can_only_delete_your_friendships]
    redirect_to current_user
  end

  def read_messages
    @messages.each do |message|
      message.read_message if !message.read? && message.receiver_id == current_user.id
    end
  end
end
