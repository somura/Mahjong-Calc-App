class AddKubiToTournament < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :kubi, :integer
  end
end
