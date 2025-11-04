class ForgotPasswordForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :email

  validates :email, presence: { message: "Không được để trống" }
end
