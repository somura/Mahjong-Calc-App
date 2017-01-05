class GameMemoController < ApplicationController
  def index
    @tournament_id = params['tournament_id']
    @game_id       = params['game_id']

    @memos = GameMemo.where(game_id: @game_id)
    render template: 'game_memo/index'
  end

  def new
    @tournament_id = params['tournament_id']
    @game_id       = params['game_id']
    @game_memo = GameMemo.new
    render template: 'game_memo/new'
  end

  def create
    @tournament_id = params['tournament_id']
    @game_id       = params['game_id']
    data = {
      tournament_id: @tournament_id,
      game_id:       @game_id,
      comment:       params['game_memo']['comment']
    }
    game_memo = GameMemo.new data
    game_memo.save

    redirect_to action: 'index'
  end
end
