class Carts::ProductsController < ApplicationController
  before_action :authorize_user!

  def create
    cart = Cart::ManageProductService.call(current_user, add_products_params[:product_id], add_products_params[:quantity])

    render json: cart
  end

  def destroy
    cart = Cart::DestroyProductService.call(current_user, destroy_product_params[:product_id])

    render json: cart
  end

  private

  def add_products_params
    params.permit(:product_id, :quantity)
  end

  def destroy_product_params
    params.permit(:product_id)
  end
end
