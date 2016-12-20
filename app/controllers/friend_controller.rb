class FriendController < ApplicationController
  def index
    friends = Friend.where(user_id: user_id)
    @user_names = friends.each_with_object([]) do |(friend), array|
      user = User.find(friend.friend_user_id)
      array << user.login_id # nameを登録できるようにしたらuser.nameにする
    end
    render template: 'friend/index'
  end
end
