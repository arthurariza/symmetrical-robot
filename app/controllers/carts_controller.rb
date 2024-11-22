class CartsController < ApplicationController
  before_action :authorize_user!

  def show
    cart = Cart::FindService.call(current_user)

    render json: cart
  end
end
