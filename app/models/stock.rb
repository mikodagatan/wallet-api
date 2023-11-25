class Stock < ApplicationRecord
  validates :name, :code, presence: true
end
