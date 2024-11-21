class Users::RegistrationsController < ApplicationController
  def create
    user = User::CreateService.call(registration_params[:email],
                                    registration_params[:password],
                                    registration_params[:password_confirmation])

    if user.persisted?
      render json: user, status: :created, serializer: UserSerializer
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

    def registration_params
      params.require(:registration).permit(:email, :password, :password_confirmation)
    end
end
