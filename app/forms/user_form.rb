class UserForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :id, :email, :username, :fullname, :display_name, :phone, :birth_day, :team_id, :position_id, :role_id

  validates :email, presence: { message: "Không được để trống" }
  validates :username, presence: { message: "Không được để trống" }
  validates :fullname, presence: { message: "Không được để trống" }
  validates :display_name, presence: { message: "Không được để trống" }
  validate :email_must_be_unique
  validate :username_must_be_unique

  private

  def email_must_be_unique
    if UserTeam.where.not(id: id).exists?(email: email)
      errors.add(:email, "Dữ liệu đã tồn tại, vui lòng chọn tên khác")
    end
  end

  def username_must_be_unique
    if UserTeam.where.not(id: id).exists?(username: username)
      errors.add(:username, "Dữ liệu đã tồn tại, vui lòng chọn tên khác")
    end
  end
end
