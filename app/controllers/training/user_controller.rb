class Training::UserController < AppController
  before_action :authenticate_user_team!
  layout "team"
  before_action :set_user, only: [ :edit, :update, :destroy ]

  def index
    if params[:keyword].present?
      keyword = "%#{params[:keyword]}%"
      @users = UserTeam.where(
        "email ILIKE :q OR username ILIKE :q OR display_name ILIKE :q OR fullname ILIKE :q",
        q: keyword
      ).order(created_at: :desc)
    else
      @users = UserTeam.all.order(created_at: :desc)
    end
  end

  def add
    @user = UserTeam.new
    @teams = Team.all
    @positions = Position.all
    @roles = Role.all
  end

  def create
    @user = UserTeam.new(user_params)
    if @user.save
      redirect_to user_list_path, notice: "Thêm mới thành công!"
    else
      @teams = Team.all
      @roles = Role.all
      @positions = Position.all
      flash[:alert] = "Thêm mới thất bại!"
      render :add, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
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

  def user_params
    params.require(:user_team).permit(
      :username, :email, :password,
      :fullname, :display_name, :phone,
      :birth_day, :role_id, :position_id, :team_id
    )
  end
end
