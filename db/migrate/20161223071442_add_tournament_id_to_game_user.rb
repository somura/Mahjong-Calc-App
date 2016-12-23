class AddTournamentIdToGameUser < ActiveRecord::Migration[5.0]
  def change
    add_column :game_users, :tournament_id, :integer
  end
end
