class CreateGameMemos < ActiveRecord::Migration[5.0]
  def change
    create_table :game_memos do |t|
      t.string :comment
      t.integer :gamd_id
      t.integer :tournament_id

      t.timestamps
    end
  end
end
