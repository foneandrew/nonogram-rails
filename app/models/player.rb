class Player < ActiveRecord::Base
  #t.integer :user_id, null: false
  #t.integer :game_id, null: false
  #t.boolean :won
  #t.text    :answer

  model_name.instance_variable_set :@route_key, 'player'

  belongs_to :user
  belongs_to :game

  validates :user, presence: true
  validates :game, presence: true

  def won?
    won
  end
  #index on won to find winner faster??
end
