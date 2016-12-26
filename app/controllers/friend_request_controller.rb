class FriendRequestController < ApplicationController
  include FriendRequestHelper

  def index
    friend_requests = FriendRequest.where(friend_user_id: user_id, status: 'new')
    @user_names = friend_requests.each_with_object([]) do |(friend_request), array|
      friend_user_id = friend_request.user_id
      user = User.find(friend_user_id)
      array << { name: user.name, data: friend_request }
    end
    render template: 'friend_request/index'
  end

  def new
    @friend_request = FriendRequest.new
    render template: 'friend_request/new'
  end

  def create
    friend_user_id = friend_request_params[:friend_user_id]
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
    redirect_to action: 'index'
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
      friend_user_id = friend_request.user_id
      my_friend_data = { user_id: user_id, friend_user_id: friend_user_id }
      my_friend = Friend.new my_friend_data

      friend_my_data = { user_id: friend_user_id, friend_user_id: user_id }
      friend_my = Friend.new friend_my_data

      my_friend.save
      friend_my.save
    end

    friend_request.save

    redirect_to action: 'index'
  end

  private

  def friend_request_params
    params.require(:friend_request).permit(:friend_user_id)
  end
end
