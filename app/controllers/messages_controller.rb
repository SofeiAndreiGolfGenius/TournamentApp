class MessagesController < ApplicationController
  before_action :logged_in_user
  before_action :sender, only: [:destroy]

  def create
    friendship = Friendship.find(params[:friendship_id])
    @message = friendship.messages.build(message_params)
    @message.sender_id = params[:sender_id]
    @message.receiver_id = params[:receiver_id]
    flash[:danger] = Constants::MESSAGES[:message_create_failed] unless @message.save
    redirect_to chatroom_friendship_path friendship
  end

  def destroy
    message = Message.find(params[:id])
    friendship = message.friendship
    message.destroy
    flash[:success] = Constants::MESSAGES[:message_delete_success]
    redirect_to chatroom_friendship_path(friendship)
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def sender
    message = Message.find(params[:id])
    return if message.sender_id == current_user.id

    flash[:danger] = Constants::MESSAGES[:can_only_delete_your_messages]
    redirect_to root_path
  end
end
