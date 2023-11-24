class Wallet < ApplicationRecord
  belongs_to :entity, polymorphic: true

  has_many :credit_transactions, class_name: 'Transaction', foreign_key: 'source_wallet_id'
  has_many :debit_transactions, class_name: 'Transaction', foreign_key: 'target_wallet_id'
end
