FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    price { 999.99 }
  end
end
