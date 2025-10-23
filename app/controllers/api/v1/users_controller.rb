
class Api::V1::UsersController < ApplicationController
  before_action :authorize_request
  def index
    @users = User.all
    render json: { message: "List user", users: @users }, status: :ok
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: { message: "User created successfully", user: @user }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find_by(id: params[:id])
    if @user
      render json: { user: @user }
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.nil?
      render json: { error: "User not found" }, status: :not_found
    elsif @user.update(user_params)
      render json: { message: "User updated successfully", user: @user }
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    if @user.nil?
      render json: { error: "User not found" }, status: :not_found
    elsif @user.destroy
      render json: { message: "User deleted successfully" }
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :username, :name, :phone, :password)
  end
end
