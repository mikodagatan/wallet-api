FactoryBot.define do
  factory :wallet do
    association :entity, factory: :user
  end
end
