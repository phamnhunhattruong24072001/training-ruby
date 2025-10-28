class Training::TeamController < AppController
  before_action :authenticate_user_team!
  layout "team"
  before_action :set_team, only: [ :edit, :update, :destroy ]

  def index
    if params[:keyword].present?
      @teams = Team.where("name ILIKE ?", "%#{params[:keyword]}%").order(created_at: :desc)
    else
      @teams = Team.all.order(created_at: :desc)
    end
  end

  def add
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      redirect_to team_list_path, notice: "Tạo team thành công!"
    else
      flash[:alert] = "Tạo team thất bại!"
      render :add, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @team.update(team_params)
      flash[:notice] = "Cập nhật thành công!"
      redirect_to team_list_path
    else
      flash[:alert] = "Cập nhật thất bại!"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @team.destroy
    flash[:notice] = "Xoá dữ liệu thành công!"
    redirect_to team_list_path
  end

  def set_team
    @team = Team.find(params[:id])
  end

  private

  def team_params
    params.require(:team).permit(:name, :description)
  end
end
