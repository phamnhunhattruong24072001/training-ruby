class ApplicationController < ActionController::API
  attr_reader :current_user

  private

  def authorize_request
    header = request.headers["Authorization"]

    if header
      token = header.split(" ").last
      begin
        decoded = JsonWebToken.decode(token)
        @current_user = User.find(decoded[:user_id])
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        render json: { error: "Invalid token" }, status: :unauthorized
      end
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
