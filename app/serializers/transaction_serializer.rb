class TransactionSerializer < Blueprinter::Base
  fields :id,
         :source_wallet_id,
         :target_wallet_id,
         :amount,
         :transaction_type,
         :notes
end
