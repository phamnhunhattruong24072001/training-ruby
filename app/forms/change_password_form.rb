class ChangePasswordForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :user, :current_password, :new_password, :confirm_password

  validates :current_password, presence: { message: "Không được để trống" }
  validates :new_password, presence: { message: "Không được để trống" }, length: { minimum: 6, message: "Mật khẩu phải dài ít nhất 6 ký tự" }
  validates :confirm_password, presence: { message: "Không được để trống" }
  validate :password_confirmation_match

  def password_confirmation_match
    if new_password != confirm_password
      errors.add(:confirm_password, "Không khớp với mật khẩu mới")
    end
  end
end
