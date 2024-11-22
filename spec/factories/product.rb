FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    price { '99.99' }
  end
end
