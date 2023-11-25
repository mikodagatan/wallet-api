class Stock < ApplicationRecord
  include HasWallet

  validates :name, :code, presence: true
end
