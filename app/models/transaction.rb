class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: 'Wallet', optional: true
  belongs_to :target_wallet, class_name: 'Wallet', optional: true

  enum transaction_type: %i[withdraw deposit transfer]

  validates_presence_of :amount

  after_create :update_wallet_balances

  private

  def update_wallet_balances
    source_wallet&.update_balance
    target_wallet&.update_balance
  end
end
