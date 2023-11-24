class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :source_wallet, foreign_key: { to_table: :wallets }
      t.references :target_wallet, foreign_key: { to_table: :wallets }
      t.decimal :amount, precision: 19, scale: 2
      # Add other necessary columns for your transactions
      # For example, you might need a column for transaction type, timestamp, etc.

      t.timestamps
    end
  end
end
