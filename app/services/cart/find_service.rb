class Cart::FindService < ApplicationService
  def initialize(user)
    @user = user
  end

  def call
    cart = Cart.includes([ cart_products: :product ]).where(user: @user).last

    cart = Cart.create(user: @user, total_price: "0") unless cart.present?

    cart.reload
  end
end
