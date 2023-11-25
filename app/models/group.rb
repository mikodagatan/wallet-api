class Group < ApplicationRecord
  include HasWallet

  validates :name, presence: true
end
