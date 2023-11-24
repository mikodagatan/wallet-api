class User < ApplicationRecord
  has_one :wallet, as: :entity

  validates :first_name,
            :last_name,
            :email,
            presence: true

  validates :email, uniqueness: true
end
