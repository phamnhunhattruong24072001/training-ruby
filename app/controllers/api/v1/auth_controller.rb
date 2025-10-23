class Api::V1::AuthController < ApplicationController
  before_action :authorize_request, only: [ :profile, :change_password ]

  skip_before_action :authorize_request, only: [ :login, :register, :forgot_password, :reset_password ]

  def login
    user = User.find_by(email: params[:email])

    if user && user.valid_password?(params[:password])
      token = JsonWebToken.encode(user_id: user.id)

      render json: {
        message: "Login successful",
        token: token,
        user: {
          id: user.id,
          email: user.email,
          name: user.name
        }
      }, status: :ok
    else
      render json: {
        error: "Invalid email or password"
      }, status: :unauthorized
    end
  end

  def profile
     render json: {
      data: {
        id: @current_user.id,
        email: @current_user.email,
        name: @current_user.name
      }
    }, status: :ok
  end

  def register
    user = User.new(user_params)
    if user.save
      render json: {
        message: "Register successful",
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          username: user.username
        }
      }, status: :created
    else
      render json: {
        message: "Register unsuccessful"
      }, status: :unprocessable_entity
    end
  end

  def forgot_password
    user = User.find_by(email: params[:email])

    if user
      reset_token = SecureRandom.hex(10)
      user.update(reset_password_token: reset_token, reset_password_sent_at: Time.current)

      render json: { message: "Reset password success", reset_password_token: reset_token }, status: :ok
    else
      render json: { message: "Reset password error" }, status: :not_found
    end
  end

  def reset_password
    user = User.find_by(reset_password_token: params[:token])
    if user && user.reset_password_sent_at > 2.hours.ago
      if params[:password].present? && params[:password] == params[:password_confirmation]
        user.password = params[:password]
        user.reset_password_token = nil
        user.reset_password_sent_at = nil
        user.save!

        render json: { message: "Password has been reset successfully" }, status: :ok
      else
        render json: { error: "Passwords do not match" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Invalid or expired reset token" }, status: :unprocessable_entity
    end
  end

  def change_password
    user = @current_user
    if user && user.valid_password?(params[:current_password])
      if params[:new_password].blank?
        render json: { error: "New password cannot be blank" }, status: :unprocessable_entity
      elsif params[:new_password] != params[:password_confirmation]
        render json: { error: "Password confirmation does not match" }, status: :unprocessable_entity
      else
        user.password = params[:new_password]
        if user.save
          render json: { message: "Password changed successfully" }, status: :ok
        else
          render json: { error: user.errors.full_messages }, status: :unprocessable_entity
        end
      end
    else
      render json: { error: "Current password is incorrect" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation, :name, :username)
  end
end
