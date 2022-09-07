module FriendRequestsHelper
  def friend_request(receiver, sender)
    FriendRequest.find_by(receiver_id: receiver.id, sender_id: sender.id)
  end
end
