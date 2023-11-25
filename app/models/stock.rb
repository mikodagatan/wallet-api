class Stock < ApplicationRecord
  has_one :wallet, as: :entity,
                   dependent: :destroy,
                   inverse_of: :wallet
  validates :name, :code, presence: true
end
