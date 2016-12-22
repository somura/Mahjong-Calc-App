class CreateTournaments < ActiveRecord::Migration[5.0]
  def change
    create_table :tournaments do |t|
      t.integer :def_score
      t.integer :return_score
      t.integer :uma1
      t.integer :uma2
      t.integer :uma3
      t.integer :uma4
      t.integer :point_rate
      t.integer :tip_rate
      t.integer :tobi_point
      t.string :mode

      t.timestamps
    end
  end
end
