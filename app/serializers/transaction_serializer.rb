class TransactionSerializer < Blueprinter::Base
  fields :source_wallet_id, :target_wallet_id, :amount, :transaction_type
end
