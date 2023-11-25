module TransactionValidations
  extend ActiveSupport::Concern

  included do
    validate :source_or_target_wallet_present
    validate :source_wallet_balance_not_below_zero
    validate :no_duplicate_transaction_within_1_minute

    private

    def source_or_target_wallet_present
      return if source_wallet.present? || target_wallet.present?

      errors.add(:base, 'Either source_wallet_id or target_wallet_id must be present')
    end

    def source_wallet_balance_not_below_zero
      return unless source_wallet.present?

      return unless (source_wallet.balance - amount).negative?

      errors.add(:base, 'Source wallet balance cannot go below 0')
    end

    def no_duplicate_transaction_within_1_minute
      existing_transaction = self.class.find_by(
        source_wallet:,
        target_wallet:,
        amount:,
        created_at: (Time.now - 60.seconds)..Time.now
      )

      return unless existing_transaction.present?

      errors.add(:base, 'Cannot create duplicate transaction within 1 minute')
    end
  end
end
