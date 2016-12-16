class CreateLoginSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :login_sessions do |t|
      t.text :login_session

      t.timestamps
    end
  end
end
