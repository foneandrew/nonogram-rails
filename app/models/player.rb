class Player < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  validates :user, :game, presence: true

  scope     :winners,   -> { where(won: true) }
  scope     :quitters,  -> { where(gave_up: true) }
  scope     :for_user,  -> (user) { where(user: user) }
end