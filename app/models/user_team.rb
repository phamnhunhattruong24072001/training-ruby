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
  validates :encrypted_password, presence: true

  def super_admin?
    role.code == "super_admin"
  end

  def admin?
    role.code == "admin"
  end

  def manager?
    role.code == "manager"
  end

  def user?
    role.code == "user"
  end
end
