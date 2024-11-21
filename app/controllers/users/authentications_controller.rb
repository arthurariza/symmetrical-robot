class Users::AuthenticationsController < ApplicationController
  def create
    user = User.find_by(email: authentication_params[:email])

    if user&.authenticate(authentication_params[:password])
      render json: { token: User::GenerateJwtService.call(user) }
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  private

    def authentication_params
      params.permit(:email, :password)
    end
end
