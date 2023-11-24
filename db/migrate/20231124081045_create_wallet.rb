class CreateWallet < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
      t.references :entity, polymorphic: true, null: false
      t.decimal :balance, precision: 19, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
