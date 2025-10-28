class AllowNullForTeamAndPositionInUserTeams < ActiveRecord::Migration[8.0]
  def change
    change_column_null :user_teams, :team_id, true
    change_column_null :user_teams, :position_id, true
  end
end
