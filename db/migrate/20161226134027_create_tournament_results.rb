class CreateTournamentResults < ActiveRecord::Migration[5.0]
  def change
    create_table :tournament_results do |t|
      t.integer :tournament_id
      t.integer :user_id
      t.integer :tip
      t.integer :total_point
      t.integer :total_gold

      t.timestamps
    end
  end
end
