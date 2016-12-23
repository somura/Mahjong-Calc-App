class GameController < ApplicationController
  def index
    @games = Game.where(tournament_id: params['tournament_id'])
    render template: 'game/index'
  end

  def new
    @tournament_id = params['tournament_id']
    members = TournamentUser.where(tournament_id: @tournament_id)
    @members = members.each_with_object([]) do |(member), array|
      user = User.find(member.user_id)
      array << [ user.login_id, member.user_id ]
    end
    render template: 'game/new'
  end

  def create
    user1 = params['position1']
    user2 = params['position2']
    user3 = params['position3']
    user4 = params['position4']
    score1 = params['score1'].to_i
    score2 = params['score2'].to_i
    score3 = params['score3'].to_i
    score4 = params['score4'].to_i

    return redirect_to action: 'new', status: 400 unless user1
    return redirect_to action: 'new', status: 400 unless user2
    return redirect_to action: 'new', status: 400 unless user3
    return redirect_to action: 'new', status: 400 unless user4
    return redirect_to action: 'new', status: 400 unless score1
    return redirect_to action: 'new', status: 400 unless score2
    return redirect_to action: 'new', status: 400 unless score3
    return redirect_to action: 'new', status: 400 unless score4

    tournament = Tournament.find(params['tournament_id'])

    results = [
      { user: user4, score: score4, position: 4 },
      { user: user3, score: score3, position: 3 },
      { user: user2, score: score2, position: 2 },
      { user: user1, score: score1, position: 1 },
    ]

    if results.map {|r| r[:user] }.uniq.size != 4
      return redirect_to action: 'new', status: 400
    end
    if results.map {|r| r[:score] }.inject(:+) != 100000
      return redirect_to action: 'new', status: 400
    end

    results = results.sort_by {|r| r[:score] }.reverse
    results.each_with_index do |result, i|
      point = result[:score] / 1000
      if point > 0
        if (point - point.to_i) >= 0.6
          point = (point + 1).to_i
        else
          point = point.to_i
        end
      else
        if (point - point.to_i).abs >= 0.6
          point = (point - 1).to_i
        else
          point = point.to_i
        end
      end
      point += tournament.send("uma#{i + 1}") - (tournament.return_score.to_i / 1000)
      results[i][:point] = point
    end
    diff = results.map {|r| r[:point] }.inject(:+)
    results[0][:point] -= diff

    game = Game.new tournament_id: tournament.id
    game.save
    results.each_with_index do |result, i|
      game_user_data = {
        game_id:  game.id,
        user_id:  result[:user],
        score:    result[:score],
        point:    result[:point],
        rank:     i + 1,
        position: result[:position],
      }
      game_user = GameUser.new game_user_data
      game_user.save
    end

    redirect_to action: 'index'
  end
end
