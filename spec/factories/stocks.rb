FactoryBot.define do
  factory :stock do
    sequence(:name) { |i| "Stock #{i}" }
    sequence(:code) { |i| "code#{i}" }
  end
end
