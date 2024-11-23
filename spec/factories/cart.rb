FactoryBot.define do
  factory :cart do
    user
    total_price { '0.0' }
    abandoned { false }
    last_interaction_at { DateTime.now }
  end
end
