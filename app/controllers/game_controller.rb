class GameController < ApplicationController
  def index
    @tournament_id = params['tournament_id']
    members = TournamentUser.where(tournament_id: @tournament_id)
    @members = members.each_with_object([]) do |(member), array|
      user = User.find(member.user_id)
      array << user
    end

    games = Game.where(tournament_id: params['tournament_id'])
    @games = games.each_with_object([]) do |(game), array|
      data = @members.each_with_object([]) do |(member), _array|
        result = { user_id: member.id, name: member.login_id }
        game_user = GameUser.where(game_id: game.id, user_id: member.id)
        unless game_user.empty?
          result[:point] = game_user.first.point
          result[:rank] = game_user.first.rank
        end
        _array << result
      end
      array << { game_id: game.id, data: data }
    end

    @data = @members.each_with_object([]) do |(member), array|
      i = 0
      point = 0
      data = games.each_with_object([]) do |(game), _array|
        i += 1
        game_user = GameUser.where(game_id: game.id, user_id: member.id)
        point += game_user.first.point unless game_user.empty?
        _array << [i, point]
      end
      array << { name: member.login_id, data: data }
    end
    p @data

    @results = members.each_with_object([]) do |(member), array|
      game_users = GameUser.where(tournament_id: @tournament_id, user_id: member.user_id)
      array << game_users.map {|game_user| game_user.point.to_i }.inject(:+)
    end
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
        tournament_id: tournament.id,
        game_id:       game.id,
        user_id:       result[:user],
        score:         result[:score],
        point:         result[:point],
        rank:          i + 1,
        position:      result[:position],
      }
      game_user = GameUser.new game_user_data
      game_user.save
    end

    redirect_to action: 'index'
  end

  def edit
    @tournament_id = params['tournament_id']
    @game_id       = params['id']

    members = TournamentUser.where(tournament_id: @tournament_id)
    @members = members.each_with_object([]) do |(member), array|
      user = User.find(member.user_id)
      array << [ user.login_id, member.user_id ]
    end

    game_users = GameUser.where(game_id: @game_id)
    @game_users = [1, 2, 3, 4].each_with_object([]) do |(i), array|
      game_user = game_users.select {|g| g.position.to_i == i }
      user = User.find(game_user.first.user_id)
      array << { user: user.id, score: game_user.first.score }
    end

    render template: 'game/edit'
  end

  def update
    @game_id = params['id']
    user1 = params['position1']
    user2 = params['position2']
    user3 = params['position3']
    user4 = params['position4']
    score1 = params['score1'].to_i
    score2 = params['score2'].to_i
    score3 = params['score3'].to_i
    score4 = params['score4'].to_i

    return redirect_to action: 'new', status: 401 unless user1
    return redirect_to action: 'new', status: 402 unless user2
    return redirect_to action: 'new', status: 403 unless user3
    return redirect_to action: 'new', status: 404 unless user4
    return redirect_to action: 'new', status: 405 unless score1
    return redirect_to action: 'new', status: 406 unless score2
    return redirect_to action: 'new', status: 407 unless score3
    return redirect_to action: 'new', status: 408 unless score4

    tournament = Tournament.find(params['tournament_id'])

    results = [
      { user: user4, score: score4, position: 4 },
      { user: user3, score: score3, position: 3 },
      { user: user2, score: score2, position: 2 },
      { user: user1, score: score1, position: 1 },
    ]

    if results.map {|r| r[:user] }.uniq.size != 4
      return redirect_to action: 'new', status: 409
    end
    if results.map {|r| r[:score] }.inject(:+) != 100000
      return redirect_to action: 'new', status: 410
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

    game_users = GameUser.where(game_id: @game_id)
    game_users.each do |game_user|
      game_user.destroy
    end

    results.each_with_index do |result, i|
      game_user_data = {
        tournament_id: tournament.id,
        game_id:       @game_id,
        user_id:       result[:user],
        score:         result[:score],
        point:         result[:point],
        rank:          i + 1,
        position:      result[:position],
      }
      game_user = GameUser.new game_user_data
      game_user.save
    end

    redirect_to action: 'index'
  end
end
