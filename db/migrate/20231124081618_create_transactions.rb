class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions, id: :uuid do |t|
      t.references :source_wallet, foreign_key: { to_table: :wallets }, type: :uuid, index: true
      t.references :target_wallet, foreign_key: { to_table: :wallets }, type: :uuid, index: true
      t.decimal :amount, precision: 19, scale: 2, null: false
      t.integer :transaction_type, null: false
      t.text :notes

      t.timestamps
    end
  end
end
