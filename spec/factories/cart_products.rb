FactoryBot.define do
  factory :cart_product do
    cart
    product
    quantity { 1 }
    unit_price { "9.99" }
  end
end
