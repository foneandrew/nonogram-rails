class User < ActiveRecord::Base
  ACCEPTABLE_CHARS_IN_NAME = /\A[\w\- ]+\z/
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :players, dependent: :destroy
  has_many :games, dependent: :destroy
  has_many :nonograms
  has_many :player_games, through: :players, source: :game

  validates :name, presence: true, uniqueness: { message: 'already taken by another user' }
  validates :name, format: { with: ACCEPTABLE_CHARS_IN_NAME,
    message: 'contains invalid characters' }
end
