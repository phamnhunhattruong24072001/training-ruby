class Training::UserController < AppController
  before_action :authenticate_user_team!
  layout "team"
  before_action :set_user, only: [ :edit, :update, :destroy ]
  before_action :authorize_user_access, only: [ :add, :create, :edit, :update, :destroy ]
  require "bcrypt"

  def index
    role = current_user_team.role.code

    @users = case role
    when "super_admin", "admin"
      UserTeam.all
    when "manager", "user"
      UserTeam.where(team_id: current_user_team.team_id)
    else
      UserTeam.none
    end

    if params[:keyword].present?
      keyword = "%#{params[:keyword]}%"
      @users = @users.where(
        "email ILIKE :q OR username ILIKE :q OR display_name ILIKE :q OR fullname ILIKE :q",
        q: keyword
      )
    end

    @users = @users.order(created_at: :desc)
  end

  def add
    @user = UserTeam.new
    load_form_data
  end

  def create
    @user = UserTeam.new(user_params)
    @user.password = "12345678"
    @user.password_confirmation = "12345678"
    if @user.save
      redirect_to user_list_path, notice: "Thêm mới thành công!"
    else
      load_form_data
      flash[:alert] = "Thêm mới thất bại!"
      render :add, status: :unprocessable_entity
    end
  end

  def edit
   load_form_data
  end

  def update
    load_form_data
    if @user.update(user_params)
      flash[:notice] = "Cập nhật thành công!"
      redirect_to user_list_path
    else
      flash[:alert] = "Cập nhật thất bại!"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = "Xoá dữ liệu thành công!"
    redirect_to user_list_path
  end

  def set_user
    @user = UserTeam.find(params[:id])
  end

  private

  def load_form_data
    role = current_user_team.role.code

    case role
    when "super_admin"
      @roles = Role.all
      @teams = Team.all

    when "admin"
      @roles = Role.where(code: [ "manager", "user" ])
      @teams = Team.all

    when "manager"
      @roles = Role.where(code: "user")
      @teams = Team.where(id: current_user_team.team_id)

    else # role == "user"
      @roles = Role.where(code: "user")
      @teams = Team.where(id: current_user_team.team_id)
    end

    @positions = Position.all
  end

  def user_params
    params.require(:user_team).permit(
      :username, :email,
      :fullname, :display_name, :phone,
      :birth_day, :role_id, :position_id, :team_id
    )
  end

  def authorize_user_access
    role = current_user_team.role.code

    case role
    when "super_admin"
      nil

    when "admin"
      if @user&.role&.code == "super_admin" || @user == current_user_team
        flash[:alert] = "Bạn không có quyền chỉnh sửa hoặc xoá tài khoản này!"
        redirect_to user_list_path
      end

    when "manager"
      if @user.present?
        unless @user.role.code == "user" && @user.team_id == current_user_team.team_id
          flash[:alert] = "Bạn chỉ được quản lý người dùng trong team của mình!"
          redirect_to user_list_path
        end
      end

    else
      flash[:alert] = "Bạn không có quyền truy cập vào chức năng này!"
      redirect_to user_list_path
    end
  end
end
