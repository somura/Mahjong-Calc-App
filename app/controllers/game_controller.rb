class GameController < ApplicationController
  def index
    @tournament_id = params['tournament_id']

    tournament = Tournament.find(@tournament_id)
    @mode = tournament.mode

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
      data = data.unshift([0, 0])
      array << { name: member.name, data: data }
    end

    @results = members.each_with_object([]) do |(member), array|
      game_users = GameUser.where(tournament_id: @tournament_id, user_id: member.user_id)
      array << game_users.map {|game_user| game_user.point.to_i }.inject(:+)
    end

    @totals = members.each_with_object([]) do |(member), array|
      tournament_results = TournamentResult.where(tournament_id: @tournament_id, user_id: member.user_id)
      tournament_result = tournament_results.first
      array << { total: tournament_result.total_gold, tip: tournament_result.tip }
    end
    render template: 'game/index'
  end

  def new
    @tournament_id = params['tournament_id']

    tournament = Tournament.find(@tournament_id)
    @mode = tournament.mode

    game = Game.where(tournament_id: @tournament_id).order("id DESC").limit(1)
    if game.empty?
      @before_members = []
    else
      game_users = GameUser.where(tournament_id: @tournament_id, game_id: game.first.id)
      @before_members = game_users.sort_by {|game_user| game_user.position }.map {|m| m.user_id }
    end

    members = TournamentUser.where(tournament_id: @tournament_id)
    @members = members.each_with_object([]) do |(member), array|
      user = User.find(member.user_id)
      array << [ user.name, member.user_id ]
    end
    render template: 'game/new'
  end

  def create
    tournament = Tournament.find(params['tournament_id'])
    @mode = tournament.mode

    user1 = params['position1']
    user2 = params['position2']
    user3 = params['position3']
    score1 = params['score1'].to_i
    score2 = params['score2'].to_i
    score3 = params['score3'].to_i

    return redirect_to action: 'new', status: 400 unless user1
    return redirect_to action: 'new', status: 400 unless user2
    return redirect_to action: 'new', status: 400 unless user3
    return redirect_to action: 'new', status: 400 unless score1
    return redirect_to action: 'new', status: 400 unless score2
    return redirect_to action: 'new', status: 400 unless score3

    results = nil
    if @mode == '4ma'
      user4 = params['position4']
      score4 = params['score4'].to_i

      return redirect_to action: 'new', status: 400 unless user4
      return redirect_to action: 'new', status: 400 unless score4

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
    else
      results = [
        { user: user3, score: score3, position: 3 },
        { user: user2, score: score2, position: 2 },
        { user: user1, score: score1, position: 1 },
      ]
      if results.map {|r| r[:user] }.uniq.size != 3
        return redirect_to action: 'new', status: 400
      end

      if @mode == '3ma'
        if results.map {|r| r[:score] }.inject(:+) != 105000
          return redirect_to action: 'new', status: 400
        end
      else
        if results.map {|r| r[:score] }.inject(:+) != 45000
          return redirect_to action: 'new', status: 400
        end
      end
    end

    if tournament.tobi_point
      tobi = results.select {|r| r[:score] < 0 }.size
      tobashi = 0
      (1..3).each do |i|
        next unless params["tobashi#{i}"]
        tobashi += params["tobashi#{i}"].size * i
      end
      return redirect_to action: 'new', status: 401 unless tobi == tobashi
    end

    results = results.sort_by {|r| r[:score] }.reverse
    results.each_with_index do |result, i|
      point = 0
      if @mode == 'toutenko'
        point = result[:score] / 100
        point += tournament.send("uma#{i + 1}") - (tournament.return_score.to_i / 100)
      else
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
      end

      if tournament.tobi_point
        if result[:score] < 0
          point -= tournament.tobi_point
        end
        (1..3).each do |index|
          next unless params["tobashi#{index}"]
          params["tobashi#{index}"].each do |t|
            point += tournament.tobi_point * index if result[:position] == t.to_i
          end
        end
      end
      results[i][:point] = point
    end

    if @mode == 'toutenko'
      if results[1][:score] >= tournament.kubi.to_i
        results[1][:point] += 10
        results[2][:point] -= 10
      else
        results[1][:point] -= 10
        results[0][:point] += 10
      end
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

      tournament_results = TournamentResult.where(tournament_id: tournament.id, user_id: result[:user])
      tournament_result = tournament_results.first
      tournament_result.total_point = tournament_result.total_point.to_i + result[:point]
      tournament_result.save
    end

    redirect_to action: 'index'
  end

  def edit
    @tournament_id = params['tournament_id']
    @game_id       = params['id']

    tournament = Tournament.find(@tournament_id)
    @mode = tournament.mode

    members = TournamentUser.where(tournament_id: @tournament_id)
    @members = members.each_with_object([]) do |(member), array|
      user = User.find(member.user_id)
      array << [ user.name, member.user_id ]
    end

    game_users = GameUser.where(game_id: @game_id)
    count = (@mode == '4ma') ? [*1..4] : [*1..3]
    @game_users = count.each_with_object([]) do |(i), array|
      game_user = game_users.select {|g| g.position.to_i == i }
      user = User.find(game_user.first.user_id)
      array << { user: user.id, score: game_user.first.score }
    end

    render template: 'game/edit'
  end

  def update
    tournament = Tournament.find(params['tournament_id'])
    @mode = tournament.mode

    user1 = params['position1']
    user2 = params['position2']
    user3 = params['position3']
    score1 = params['score1'].to_i
    score2 = params['score2'].to_i
    score3 = params['score3'].to_i

    return redirect_to action: 'new', status: 400 unless user1
    return redirect_to action: 'new', status: 400 unless user2
    return redirect_to action: 'new', status: 400 unless user3
    return redirect_to action: 'new', status: 400 unless score1
    return redirect_to action: 'new', status: 400 unless score2
    return redirect_to action: 'new', status: 400 unless score3

    results = nil
    if @mode == '4ma'
      user4 = params['position4']
      score4 = params['score4'].to_i

      return redirect_to action: 'new', status: 400 unless user4
      return redirect_to action: 'new', status: 400 unless score4

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
    else
      results = [
        { user: user3, score: score3, position: 3 },
        { user: user2, score: score2, position: 2 },
        { user: user1, score: score1, position: 1 },
      ]
      if results.map {|r| r[:user] }.uniq.size != 3
        return redirect_to action: 'new', status: 400
      end

      if @mode == '3ma'
        if results.map {|r| r[:score] }.inject(:+) != 105000
          return redirect_to action: 'new', status: 400
        end
      else
        if results.map {|r| r[:score] }.inject(:+) != 45000
          return redirect_to action: 'new', status: 400
        end
      end
    end

    if tournament.tobi_point
      tobi = results.select {|r| r[:score] < 0 }.size
      tobashi = 0
      (1..3).each do |i|
        next unless params["tobashi#{i}"]
        tobashi += params["tobashi#{i}"].size * i
      end
      @game_id = params['id']
      return redirect_to action: 'edit', id: @game_id, status: 400 unless tobi == tobashi
    end

    results = results.sort_by {|r| r[:score] }.reverse
    results.each_with_index do |result, i|
      point = 0
      if @mode == 'toutenko'
        point = result[:score] / 100
        point += tournament.send("uma#{i + 1}") - (tournament.return_score.to_i / 100)
      else
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
      end

      if tournament.tobi_point
        if result[:score] < 0
          point -= tournament.tobi_point
        end
        (1..3).each do |index|
          next unless params["tobashi#{index}"]
          params["tobashi#{index}"].each do |t|
            point += tournament.tobi_point * index if result[:position] == t.to_i
          end
        end
      end
      results[i][:point] = point
    end

    if @mode == 'toutenko'
      if results[1][:score] >= tournament.kubi.to_i
        results[1][:point] += 10
        results[2][:point] -= 10
      else
        results[1][:point] -= 10
        results[0][:point] += 10
      end
    end
    diff = results.map {|r| r[:point] }.inject(:+)
    results[0][:point] -= diff

    game_users = GameUser.where(game_id: @game_id)
    game_users.each do |game_user|
      tournament_results = TournamentResult.where(tournament_id: tournament.id, user_id: game_user.user_id)
      tournament_result = tournament_results.first
      tournament_result.total_point = tournament_result.total_point.to_i - game_user.point
      tournament_result.save
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

      tournament_results = TournamentResult.where(tournament_id: tournament.id, user_id: result[:user])
      tournament_result = tournament_results.first
      tournament_result.total_point = tournament_result.total_point.to_i + result[:point]
      tournament_result.save
    end

    redirect_to action: 'index'
  end
end
