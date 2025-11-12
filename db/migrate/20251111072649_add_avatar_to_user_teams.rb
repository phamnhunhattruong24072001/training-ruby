class AddAvatarToUserTeams < ActiveRecord::Migration[8.0]
  def change
    add_column :user_teams, :avatar, :string
  end
end
