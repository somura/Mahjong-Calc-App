class TournamentController < ApplicationController
  def index
    tournament_users = TournamentUser.where(user_id: user_id)
    @tournaments = tournament_users.each_with_object([]) do |(tournament_user), array|
      array << Tournament.find(tournament_user.tournament_id)
    end
    render template: 'tournament/index'
  end

  def new
    friends = Friend.where(user_id: user_id)
    @friend_data = friends.each_with_object([]) do |(friend), array|
      array << User.find(friend.friend_user_id)
    end
    render template: 'tournament/new'
  end

  def create
    return redirect_to action: 'new', status: 400 unless params['mode']
    return redirect_to action: 'new', status: 400 unless params['def_score']
    return redirect_to action: 'new', status: 400 unless params['return_score']
    return redirect_to action: 'new', status: 400 unless params['return_score']
    uma = [ params['uma1'], params['uma2'], params['uma3'], params['uma4'] ].map {|m| m.to_i }
    unless uma.inject {|sum, n| sum + n } == 0
      return redirect_to action: 'new', status: 400
    end
    return redirect_to action: 'new', status: 400 if params['members'].size < 3
    tournament_data = {
      mode:         params['mode'],
      def_score:    params['def_score'],
      return_score: params['return_score'],
      uma1:         uma[0],
      uma2:         uma[1],
      uma3:         uma[2],
      uma4:         uma[3],
      point_rate:   params['point_rate'],
      tip_rate:     params['tip_rate'],
      tobi_point:   params['tobi_point']
    }
    tournament = Tournament.new tournament_data
    tournament.save
    (params['members'] + [user_id]).each do |member_id|
      tournament_user_data = { tournament_id: tournament.id, user_id: member_id }
      tournament_user = TournamentUser.new tournament_user_data
      tournament_user.save
    end

    redirect_to action: 'index'
  end

  def edit
    @tournament_id = params['id']
    @setting = Tournament.find(@tournament_id)
    tournament_users = TournamentUser.where(tournament_id: @tournament_id)
    @members = tournament_users.each_with_object({}) do |(user), hash|
      hash["#{user.user_id}"] = true
    end

    friends = Friend.where(user_id: user_id)
    @friend_data = friends.each_with_object([]) do |(friend), array|
      array << User.find(friend.friend_user_id)
    end
    render template: 'tournament/edit'
  end

  def update
    tournament_id = params['id']

    return redirect_to action: 'index', status: 400 unless params['mode']
    return redirect_to action: 'index', status: 400 unless params['def_score']
    return redirect_to action: 'index', status: 400 unless params['return_score']
    return redirect_to action: 'index', status: 400 unless params['return_score']
    uma = [ params['uma1'], params['uma2'], params['uma3'], params['uma4'] ].map {|m| m.to_i }
    unless uma.inject {|sum, n| sum + n } == 0
      return redirect_to action: 'index', status: 400
    end
    return redirect_to action: 'index', status: 400 if params['members'].size < 3
    tournament = Tournament.find(tournament_id)
    tournament.mode         = params['mode']
    tournament.def_score    = params['def_score']
    tournament.return_score = params['return_score']
    tournament.uma1         = uma[0]
    tournament.uma2         = uma[1]
    tournament.uma3         = uma[2]
    tournament.uma4         = uma[3]
    tournament.point_rate   = params['point_rate']
    tournament.tip_rate     = params['tip_rate']
    tournament.tobi_point   = params['tobi_point']
    tournament.save

    tournament_users = TournamentUser.where(tournament_id: tournament_id)
    tournament_users.each do |user|
      user.destroy
    end

    (params['members'] + [user_id]).each do |member_id|
      tournament_user_data = { tournament_id: tournament.id, user_id: member_id }
      tournament_user = TournamentUser.new tournament_user_data
      tournament_user.save
    end

    redirect_to action: 'index'
  end
end
