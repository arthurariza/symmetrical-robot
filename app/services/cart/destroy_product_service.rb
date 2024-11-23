class Cart::DestroyProductService < ApplicationService
  def initialize(user, product_id)
    @user = user
    @product_id = product_id
  end

  def call
    cart = find_cart
    product = find_product_in_cart!(cart)

    destroy_product_in_cart!(product)

    cart.update_total_price!
    cart.update_last_interaction

    cart
  end

  private

  def find_product_in_cart!(cart)
    product = cart.cart_products.find_by(product_id: @product_id)

    raise ActiveRecord::RecordNotFound, "Product was not found in cart" unless product.present?

    product
  end

  def find_cart
    Cart::FindService.call(@user)
  end

  def destroy_product_in_cart!(product)
    product.destroy!
  end
end
