class CreateTournamentUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :tournament_users do |t|
      t.integer :tournament_id
      t.integer :user_id

      t.timestamps
    end
  end
end
