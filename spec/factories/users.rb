FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "admin#{n}@admin.com" }
    password_digest { BCrypt::Password.create("some_password") }
  end
end
