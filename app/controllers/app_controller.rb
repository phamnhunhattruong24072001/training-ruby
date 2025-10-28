class AppController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user_team

  def current_user_team
    @current_user_team ||= UserTeam.find_by(id: session[:user_team_id]) if session[:user_team_id]
  end

  def authenticate_user_team!
    unless current_user_team
      redirect_to login_path
    end
  end
end
