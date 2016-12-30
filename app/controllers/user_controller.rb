class UserController < ApplicationController
  def show
    @results = { four: {}, three: {}, toutenko: {} }
    map = { four: '4ma', three: '3ma', toutenko: 'toutenko' }

    friend_id = params['id']
    return redirect_to controller: 'my_page', action: 'index' if friend_id == user_id

    friends = Friend.where(friend_user_id: friend_id)
    return redirect_to controller: 'my_page', action: 'index', status: 400 if friends.empty?

    @friend = User.find(friend_id)
    map.each do |label, mode|
      result = {}
      result[:win]  = 0
      result[:lose] = 0
      result[:tournament_count] = 0
      my_tus = TournamentUser.where(user_id: user_id)
      my_tus.each do |my_tu|
        fri_tus = TournamentUser.where(tournament_id: my_tu.tournament_id, user_id: friend_id)
        unless fri_tus.empty?
          tournament = Tournament.find(fri_tus.first.tournament_id)
          next unless tournament.mode == mode

          result[:tournament_count] += 1
          my_gus = GameUser.where(tournament_id: my_tu.tournament_id, user_id: user_id)
          my_gus.each do |my_gu|
            fri_gus = GameUser.where(tournament_id: my_gu.tournament_id, user_id: friend_id)
            unless fri_gus.empty?
              if my_gu.rank.to_i > fri_gus.first.rank.to_i
                result[:lose] += 1
              else
                result[:win] += 1
              end
            end
          end
        end
      end

      @results[label] = result
    end

    render template: 'user/show'
  end
end
