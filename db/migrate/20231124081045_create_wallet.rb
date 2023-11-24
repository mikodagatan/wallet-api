class CreateWallet < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'uuid-ossp'
    enable_extension 'pgcrypto'

    create_table :wallets, id: :uuid do |t|
      t.references :entity, polymorphic: true, null: false, type: :uuid, index: true
      t.decimal :balance, precision: 19, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
