class Transaction < ApplicationRecord
  include TransactionValidations

  belongs_to :source_wallet, class_name: 'Wallet', optional: true
  belongs_to :target_wallet, class_name: 'Wallet', optional: true

  enum transaction_type: %i[withdrawal deposit transfer]

  validates :amount, presence: true, numericality: { greater_than: 0 }

  before_validation :assign_transaction_type
  after_create :update_wallet_balances

  private

  def update_wallet_balances
    source_wallet&.update_balance
    target_wallet&.update_balance
  end

  def assign_transaction_type
    self.transaction_type = if source_wallet.present? && !target_wallet.present?
                              :withdrawal
                            elsif !source_wallet.present? && target_wallet.present?
                              :deposit
                            else
                              :transfer
                            end
  end
end
