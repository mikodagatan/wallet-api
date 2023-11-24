class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: 'Wallet', optional: true
  belongs_to :target_wallet, class_name: 'Wallet', optional: true

  enum transaction_type: %i[withdrawal deposit transfer]

  validates :amount, presence: true, numericality: { greater_than: 0 }

  validate :source_or_target_wallet_present
  validate :no_duplicate_transaction_within_1_minute

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

  def source_or_target_wallet_present
    return if source_wallet.present? || target_wallet.present?

    errors.add(:base, 'Either source_wallet_id or target_wallet_id must be present')
  end

  def no_duplicate_transaction_within_1_minute
    existing_transaction = Transaction.find_by(
      source_wallet:,
      target_wallet:,
      amount:,
      created_at: (Time.now - 60.seconds)..Time.now
    )

    return unless existing_transaction.present?

    errors.add(:base, 'Cannot create duplicate transaction within 1 minute')
  end
end
