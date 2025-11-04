class ResetPasswordForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :new_password, :confirm_password

  validates :new_password, presence: { message: "Không được để trống" }
  validates :confirm_password, presence: { message: "Không được để trống" }
  validate :password_confirmation_match

  def password_confirmation_match
    if new_password != confirm_password
      errors.add(:confirm_password, "Không khớp với mật khẩu mới")
    end
  end
end
