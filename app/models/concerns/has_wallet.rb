module HasWallet
  extend ActiveSupport::Concern

  included do
    has_one :wallet, as: :entity,
                     dependent: :destroy,
                     inverse_of: :entity

    after_create :create_wallet
  end
end
