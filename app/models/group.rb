class Group < ApplicationRecord
  has_one :wallet, as: :entity,
                   dependent: :destroy,
                   inverse_of: :wallet
  validates :name, presence: true
end
