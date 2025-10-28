class Training::HomeController < AppController
  before_action :authenticate_user_team!
  layout "team"
  def index
  end
end
