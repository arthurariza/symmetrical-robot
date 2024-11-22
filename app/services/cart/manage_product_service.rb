class Cart::ManageProductService < ApplicationService
  def initialize(user, product_id, quantity)
    @user = user
    @product_id = product_id
    @quantity = quantity
  end

  def call
    product = find_product!
    cart = find_cart

    update_cart_product(cart, product)

    update_cart_total_price(cart)

    cart
  end

  private

  def find_product!
    product = Product.find_by(id: @product_id)

    raise ActiveRecord::RecordNotFound, "Product not found" unless product.present?

    product
  end

  def find_cart
    Cart::FindService.call(@user)
  end

  def update_cart_product(cart, product)
    cart_product = cart.cart_products.find_or_initialize_by(product_id: @product_id)
    cart_product.quantity += @quantity
    cart_product.unit_price = product.price
    cart_product.save
  end

  def update_cart_total_price(cart)
    cart.total_price = cart.cart_products.sum(&:total_price)
    cart.save
  end
end
