class Player < ActiveRecord::Base
  #t.integer :user_id, null: false
  #t.integer :game_id, null: false
  #t.boolean :won
  #t.text    :answer

  belongs_to :user
  belongs_to :game

  #index on won to find winner faster??
end
