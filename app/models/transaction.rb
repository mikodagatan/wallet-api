class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: 'Wallet', optional: true
  belongs_to :target_wallet, class_name: 'Wallet', optional: true

  validates_presence_of :amount

  after_create :update_wallet_balances

  private

  def update_wallet_balances
    # Implement logic to update wallet balances
  end
end
