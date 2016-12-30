class MyPageController < ApplicationController
  def index
    @results = { four: {}, three: {}, toutenko: {} }
    map = { four: '4ma', three: '3ma', toutenko: 'toutenko' }

    tournament_results = TournamentResult.where(user_id: user_id)
    map.each do |label, mode|
      result = {}

      results = tournament_results.select do |tournament_result|
        tournament = Tournament.find(tournament_result.tournament_id)
        tournament.mode == mode
      end
      result[:tournament_count] = results.size
      result[:gold]  = 0
      result[:point] = 0
      result[:tip]   = 0
      results.each do |tournament_result|
        result[:gold]  += tournament_result.total_gold.to_i
        result[:point] += tournament_result.total_point.to_i
        result[:tip]   += tournament_result.tip.to_i

        tournament_id = tournament_result.tournament_id
        game_users = GameUser.where(tournament_id: tournament_id, user_id: user_id)
        result[:game_count] = game_users.size

        first_game_users = GameUser.where(tournament_id: tournament_id, user_id: user_id, rank: 1)
        result[:first_count] = first_game_users.size

        second_game_users = GameUser.where(tournament_id: tournament_id, user_id: user_id, rank: 2)
        result[:second_count] = second_game_users.size

        third_game_users = GameUser.where(tournament_id: tournament_id, user_id: user_id, rank: 3)
        result[:third_count] = third_game_users.size

        fourth_game_users = GameUser.where(tournament_id: tournament_id, user_id: user_id, rank: 4)
        result[:fourth_count] = fourth_game_users.size

        unless result[:game_count] == 0
          result[:average_position] = (result[:first_count] + result[:second_count] * 2 + result[:third_count] * 3 + result[:fourth_count] * 4).to_f / result[:game_count]
        end
      end
      @results[label] = result
    end
    @user_id = user_id
    user = User.find(user_id)
    @name = user.name

    render template: 'my_page/index'
  end
end
