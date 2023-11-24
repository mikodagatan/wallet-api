class Wallet < ApplicationRecord
  belongs_to :entity, polymorphic: true

  has_many :credit_transactions, class_name: 'Transaction', foreign_key: 'source_wallet_id'
  has_many :debit_transactions, class_name: 'Transaction', foreign_key: 'target_wallet_id'

  def all_transactions
    Transaction.where('source_wallet_id = :wallet_id OR target_wallet_id = :wallet_id', wallet_id: id)
  end

  def update_balance
    credits = credit_transactions.sum(:amount)
    debits = debit_transactions.sum(:amount)
    update(balance: debits - credits)
  end
end
