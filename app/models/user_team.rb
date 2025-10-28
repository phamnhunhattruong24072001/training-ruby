class UserTeam < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :role
  belongs_to :position, optional: true
  belongs_to :team, optional: true

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
end
