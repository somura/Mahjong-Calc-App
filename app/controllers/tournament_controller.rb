class TournamentController < ApplicationController
  def index
    tournament_users = TournamentUser.where(user_id: user_id)
    @tournaments = tournament_users.each_with_object([]) do |(tournament_user), array|
      array << Tournament.find(tournament_user.tournament_id)
    end
    render template: 'tournament/index'
  end

  def new
    @tournament = Tournament.new

    friends = Friend.where(user_id: user_id)
    @friend_data = friends.each_with_object([]) do |(friend), array|
      array << User.find(friend.friend_user_id)
    end
    render template: 'tournament/new'
  end

  def create
    uma = [
      tournament_params[:uma1],
      tournament_params[:uma2],
      tournament_params[:uma3],
      tournament_params[:uma4]
    ].map {|m| m.to_i }
    unless uma.inject {|sum, n| sum + n } == 0
      return redirect_to action: 'new', status: 400
    end
    return redirect_to action: 'new', status: 400 if params['members'].size < 3
    tournament = Tournament.new tournament_params
    tournament.save
    (params['members'] + [user_id]).each do |member_id|
      tournament_user_data = { tournament_id: tournament.id, user_id: member_id }
      tournament_user = TournamentUser.new tournament_user_data
      tournament_user.save
      tournament_result = TournamentResult.new tournament_user_data
      tournament_result.save
    end

    redirect_to action: 'index'
  end

  def edit
    @tournament_id = params['id']
    @tournament = Tournament.find(@tournament_id)
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

    uma = [
      tournament_params[:uma1],
      tournament_params[:uma2],
      tournament_params[:uma3],
      tournament_params[:uma4]
    ].map {|m| m.to_i }
    unless uma.inject {|sum, n| sum + n } == 0
      return redirect_to action: 'index', status: 400
    end
    return redirect_to action: 'index', status: 400 if params['members'].size < 3

    tournament = Tournament.find(tournament_id)
    tournament.update tournament_params
    tournament.save

    tournament_users = TournamentUser.where(tournament_id: tournament_id)
    tournament_users.each do |user|
      user.destroy
    end

    (params['members'] + [user_id]).each do |member_id|
      tournament_user_data = { tournament_id: tournament.id, user_id: member_id }
      tournament_user = TournamentUser.new tournament_user_data
      tournament_user.save
      tournament_result = TournamentResult.new tournament_user_data
      tournament_result.save
    end

    redirect_to action: 'index'
  end

  private

  def tournament_params
    params.require(:tournament).permit(:mode, :def_score, :return_score, :uma1, :uma2, :uma3, :uma4, :point_rate, :tip_rate, :tobi_point)
  end
end
