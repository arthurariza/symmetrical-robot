class User::CreateService < ApplicationService
  def initialize(email, password, password_confirmation)
    @email = email
    @password = password
    @password_confirmation = password_confirmation
  end

  def call
    User.create(email: @email, password: @password, password_confirmation: @password_confirmation)
  end
end
