class User < ApplicationRecord
  has_one :wallet, as: :entity,
                   dependent: :destroy,
                   inverse_of: :entity

  has_many :debit_transactions, through: :wallet
  has_many :credit_transactions, through: :wallet

  validates :first_name, :last_name, presence: true
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false }

  delegate :all_transactions, to: :wallet
end
