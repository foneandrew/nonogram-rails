class Player < ActiveRecord::Base

  # model_name.instance_variable_set :@route_key, 'player'

  belongs_to :user
  belongs_to :game

  validates :user, :game, presence: true

  scope     :winners,   -> { where(won: true) }
  scope     :quitters,  -> { where(gave_up: true) }
  scope     :for_user,  -> (user) { where(user: user) }
end