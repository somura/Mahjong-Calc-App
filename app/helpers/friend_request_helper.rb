module FriendRequestHelper
  def support_status?(status)
    %w[ accepted rejected ].include? status
  end
end
