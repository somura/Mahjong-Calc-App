class AddGameIdToGameMemo < ActiveRecord::Migration[5.0]
  def change
    add_column :game_memos, :game_id, :integer
  end
end
