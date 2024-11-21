class User::GenerateJwtService < ApplicationService
  def initialize(user)
    @user = user
  end

  def call
    payload = { user_id: @user.id }

    JWT.encode(payload, ENV.fetch("JWT_SECRET"))
  end
end
