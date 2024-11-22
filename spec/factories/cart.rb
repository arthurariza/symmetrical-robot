FactoryBot.define do
  factory :cart do
    user
    total_price { '0.0' }
  end
end
