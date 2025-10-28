class Role < ApplicationRecord
  validates :name, :code, :status, presence: true

  has_many :user_teams
end
