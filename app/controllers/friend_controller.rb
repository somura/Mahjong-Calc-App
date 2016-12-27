class FriendController < ApplicationController
  def index
    friends = Friend.where(user_id: user_id)
    @users = friends.each_with_object([]) do |(friend), array|
      user = User.find(friend.friend_user_id)
      array << user
    end
    render template: 'friend/index'
  end
end
