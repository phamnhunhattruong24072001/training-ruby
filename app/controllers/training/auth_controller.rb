class Training::AuthController < AppController
  require "bcrypt"

  before_action :authenticate_user_team!, except: [ :login, :authenticate, :forgot_password, :handle_forgot_password, :reset_password, :handle_reset_password ]
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

  def change_password
    @form = ChangePasswordForm.new(user: current_user_team)
    render layout: "team"
  end

  def handle_change_password
    @user = current_user_team
    @form = ChangePasswordForm.new(
      user: @user,
      current_password: params[:current_password],
      new_password: params[:new_password],
      confirm_password: params[:confirm_password]
    )

    if @form.valid?
      unless @user && valid_password?(@user, params[:current_password])
        redirect_to change_password_path, alert: "Mật khẩu cũ không đúng!"
      end
      @user.update(password: @form.new_password)
      redirect_to change_password_path, notice: "Đổi mật khẩu thành công"
    else
      render :change_password, layout: "team"
    end
  end

  def forgot_password
    @form = ForgotPasswordForm.new
  end

  def handle_forgot_password
    @form = ForgotPasswordForm.new(email: params[:email])
    if @form.valid?
      user = UserTeam.find_by(email: params[:email])
      if user
        reset_token = SecureRandom.hex(10)
        UserMailer.forgot_password(user, reset_token).deliver_now
        user.update(reset_password_token: reset_token, reset_password_sent_at: Time.current)
        redirect_to forgot_password_path, notice: "Vui lòng đến email để thay đổi mật khẩu!"
      else
        redirect_to forgot_password_path, alert: "Tài khoản không tồn tại!"
      end
    else
      render :forgot_password
    end
  end

  def reset_password
    @token = params[:token]
    @form = ResetPasswordForm.new
  end

  def handle_reset_password
    @form = ResetPasswordForm.new(new_password: params[:new_password], confirm_password: params[:confirm_password])
    if @form.valid?
      user = UserTeam.find_by(reset_password_token: params[:token])
      if user && user.reset_password_sent_at > 20.minutes.ago
        user.update(reset_password_token: nil, reset_password_sent_at: nil, password: params[:new_password])
        redirect_to login_path, notice: "Thay đổi mật khẩu thành công!"
      else
        redirect_to forgot_password_path, alert: "Thay đổi mật khẩu không thành công!"
      end
    else
      @token = params[:token]
      render :reset_password, status: :unprocessable_entity
    end
  end

  def profile
    @form = UpdateProfileForm.new
    @user = UserTeam.find_by(id: session[:user_team_id])
    render layout: "team"
  end

  def update_profile
    @form = UpdateProfileForm.new(profile_params)
    @user = UserTeam.find_by(id: session[:user_team_id])
    if @form.valid?
      if @user.update(profile_params)
        redirect_to profile_path, notice: "Cập nhật dữ liệu thành công!"
      else
        redirect_to profile_path, alert: "Cập nhật dữ liệu thất bại!"
      end
    else
      render :profile, layout: "team", status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user_team).permit(:fullname, :display_name, :phone, :birth_day)
  end

  def valid_password?(user, password)
    bcrypt = BCrypt::Password.new(user.encrypted_password)
    bcrypt == password
  end
end
