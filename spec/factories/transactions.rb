FactoryBot.define do
  factory :transaction do
    amount { 100.0 }

    trait :withdrawal do
      source_wallet { create(:wallet) }
      target_wallet { nil }
    end

    trait :deposit do
      source_wallet { nil }
      target_wallet { create(:wallet) }
    end

    trait :transfer do
      source_wallet { create(:wallet) }
      target_wallet { create(:wallet) }
    end

    factory :withdrawal_transaction, traits: [:withdrawal]
    factory :deposit_transaction, traits: [:deposit]
    factory :transfer_transaction, traits: [:transfer]
  end
end
