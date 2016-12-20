class FriendRequestController < ApplicationController
  include FriendRequestHelper

  def index
    @friend_requests = FriendRequest.where(friend_user_id: user_id, status: 'new')
    @user_names = @friend_requests.each_with_object({}) do |(friend_request), hash|
      user = User.find(friend_request.friend_user_id)
      hash[user.id] = user.login_id # nameを登録できるようにしたらuser.nameにする
    end
    render template: 'friend_request/index'
  end

  def new
    render template: 'friend_request/new'
  end

  def create
    friend_user_id = params['friend_user_id']
    return render template: 'friend_request/new', status: 400 unless friend_user_id
    return render template: 'friend_request/new', status: 400 if friend_user_id.to_i == user_id.to_i

    friend = User.find(friend_user_id)
    return render template: 'friend_request/new', status: 404 unless friend

    friends = Friend.where(user_id: user_id, friend_user_id: friend_user_id)
    return redirect_to action: 'index' unless friends.empty?

    friend_requests = FriendRequest.where(user_id: user_id, friend_user_id: friend_user_id, status: 'new')
    return redirect_to action: 'index' unless friend_requests.empty?

    friend_request_data = { user_id: user_id, friend_user_id: friend_user_id, status: 'new' }
    friend_request = FriendRequest.new friend_request_data
    friend_request.save
    return redirect_to action: 'index'
  end

  def update
    status = nil
    status = 'accepted' if params['accepted']
    status = 'rejected' if params['rejected']
    return redirect_to action: 'index', status: 400 unless status
    return redirect_to action: 'index', status: 400 unless support_status? status

    friend_request = FriendRequest.find(params[:id])
    friend_request.status = status

    if status == 'accepted'
      friend_user_id = friend_request.friend_user_id
      friend_data = [
        { user_id: user_id,        friend_user_id: friend_user_id },
        { user_id: friend_user_id, friend_user_id: user_id }
      ]
      friend = Friend.new friend_data
      friend.save
    end

    friend_request.save

    return redirect_to action: 'index'
  end
end
