class Wallet < ApplicationRecord
  belongs_to :entity, polymorphic: true
end
