class CartsController < ApplicationController
  before_action :authorize_user!

  def show
    cart = Cart::FindService.call(current_user)

    render json: cart
  end

  def create
    cart = Cart::ManageProductService.call(current_user, cart_params[:product_id], cart_params[:quantity])

    render json: cart
  end

  private

  def cart_params
    params.permit(:product_id, :quantity)
  end
end
