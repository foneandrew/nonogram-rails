class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :user_id, null: false
      t.integer :game_id, null: false
      t.boolean :won
      t.text    :answer
      t.timestamps
    end
  end
end
