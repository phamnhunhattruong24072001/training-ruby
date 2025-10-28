class Training::AuthController < AppController
  require "bcrypt"
  def login
  end

  def authenticate
    @user = UserTeam.find_by(email: params[:email])

    if @user && valid_password?(@user, params[:password])
      session[:user_team_id] = @user.id
      redirect_to home_path
    else
      flash.now[:alert] = "Sai email hoặc mật khẩu"
      render :login, status: :unprocessable_entity
    end
  end

  def logout
    session.delete(:user_team_id)
    redirect_to login_path
  end

  private

  def valid_password?(user, password)
    bcrypt = BCrypt::Password.new(user.encrypted_password)
    bcrypt == password
  end
end
