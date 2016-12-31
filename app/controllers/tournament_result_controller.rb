class TournamentResultController < ApplicationController
  def create
    tournament_id = params['tournament_id']
    members = params['members']
    total_tip = 0
    members.each do |key, val|
      total_tip += val.to_i
    end
    return redirect_to controller: 'game', action: 'index', id: tournament_id, status: 400 unless total_tip == 0

    tournament = Tournament.find(tournament_id)
    members.each do |member_id, tip|
      tournament_results = TournamentResult.where(tournament_id: tournament_id, user_id: member_id)
      tournament_result = tournament_results.first
      tournament_result.tip = tip
      tournament_result.total_gold = tournament_result.total_point.to_i * tournament.point_rate.to_i + tip.to_i * tournament.tip_rate.to_i
      tournament_result.save
    end

    redirect_to controller: 'game', action: 'index', id: tournament_id
  end
end
