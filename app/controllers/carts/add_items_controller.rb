class Carts::AddItemsController < ApplicationController
  before_action :authorize_user!

  def create
    cart = Cart::ManageProductService.call(current_user, add_items_params[:product_id], add_items_params[:quantity])

    render json: cart
  end

  private

  def add_items_params
    params.permit(:product_id, :quantity)
  end
end
