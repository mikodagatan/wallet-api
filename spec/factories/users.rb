FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "user#{i}@email.com" }
    sequence(:first_name) { |i| "User #{i}" }
    last_name { 'Test' }
  end
end
