class CreateGameUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :game_users do |t|
      t.integer :game_id
      t.integer :user_id
      t.integer :score
      t.integer :point
      t.integer :rank
      t.integer :position

      t.timestamps
    end
  end
end
