class UsersController < ApplicationController
  def create
    @user = User.new(user_params)

    if @user.save
      render json: { message: "User created successfully", user: @user }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :username, :name, :phone, :role)
  end
end