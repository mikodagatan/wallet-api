class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :source_wallet, foreign_key: { to_table: :wallets }, index: true
      t.references :target_wallet, foreign_key: { to_table: :wallets }, index: true
      t.decimal :amount, precision: 19, scale: 2

      t.timestamps
    end
  end
end
