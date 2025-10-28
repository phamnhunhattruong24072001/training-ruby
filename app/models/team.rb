class Team < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :user_team
end
