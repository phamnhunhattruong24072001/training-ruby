class Training::HomeController < AppController
  before_action :authenticate_user_team!
  layout "team"
  def index
    @total_team = Team.count
    @total_member = UserTeam.joins(:role)
                        .where.not(roles: { code: "super_admin" })
                        .count
    @total_co_leader = UserTeam.joins(:position).where(positions: { name: "Co-Leader" }).count
    @total_dev_leader = UserTeam.joins(:position).where(positions: { name: "Leader DEV" }).count
  end
end
