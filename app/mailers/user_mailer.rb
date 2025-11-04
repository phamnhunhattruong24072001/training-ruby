class UserMailer < ApplicationMailer
  default from: "phamnhunhattruong@gmail.com"

  def forgot_password(user, token)
    @user = user
    @url  = "http://localhost:3000/reset-password/#{token}"
    mail(to: @user.email, subject: "Yêu cầu thay đổi mật khẩu")
  end
end
