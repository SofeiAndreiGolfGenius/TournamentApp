module FriendshipsHelper
  def unread_messages(user)
    messages = Message.where(receiver_id: current_user.id, sender_id: user.id, read: false)
    messages.size
  end
end
