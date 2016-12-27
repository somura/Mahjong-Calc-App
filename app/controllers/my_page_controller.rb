class MyPageController < ApplicationController
  def index
    tournament_results = TournamentResult.where(user_id: user_id)
    @tournament_count = tournament_results.size
    @gold  = 0
    @point = 0
    @tip   = 0
    tournament_results.each do |tournament_result|
      @gold  += tournament_result.total_gold.to_i
      @point += tournament_result.total_point.to_i
      @tip   += tournament_result.tip.to_i

      tournament_id = tournament_result.tournament_id
      game_users = GameUser.where(tournament_id: tournament_id, user_id: user_id)
      @game_count = game_users.size
      first_game_users = GameUser.where(tournament_id: tournament_id, user_id: user_id, rank: 1)
      @first_count = first_game_users.size
      second_game_users = GameUser.where(tournament_id: tournament_id, user_id: user_id, rank: 2)
      @second_count = second_game_users.size
      third_game_users = GameUser.where(tournament_id: tournament_id, user_id: user_id, rank: 3)
      @third_count = third_game_users.size
      fourth_game_users = GameUser.where(tournament_id: tournament_id, user_id: user_id, rank: 4)
      @fourth_count = fourth_game_users.size
      unless @game_count == 0
        @average_position = (@first_count + @second_count * 2 + @third_count * 3 + @fourth_count * 4).to_f / @game_count
      end
    end
    @user_id = user_id
    user = User.find(user_id)
    @name = user.name

    render template: 'my_page/index'
  end
end
