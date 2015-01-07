class Player < ActiveRecord::Base
  # t.integer :user_id, null: false
  # t.integer :game_id, null: false
  # t.boolean :won
  # t.text    :answer

  # model_name.instance_variable_set :@route_key, 'player'

  belongs_to :user
  belongs_to :game

  validates :user, :game, presence: true

  scope     :winners, -> { where(won: true) }
end