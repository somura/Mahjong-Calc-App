class RemoveGamdIdToGameMemo < ActiveRecord::Migration[5.0]
  def change
    remove_column :game_memos, :gamd_id, :integer
  end
end
