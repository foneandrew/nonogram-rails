class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :players, dependent: :destroy
  has_many :games, dependent: :destroy

  validates :name, presence: true, uniqueness: { message: 'already taken by another user' }
end
