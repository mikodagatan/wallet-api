module Api
  module V1
    class TransactionsController < ApplicationController
      def index
        transactions = @current_user.all_transactions
        render json: TransactionSerializer.render(transactions)
      end

      def show
        transaction = Transaction.find_by!(id: params[:id])
        render json: TransactionSerializer.render(transaction)
      end

      def create
        transaction = Transaction.new(transaction_params)

        if transaction.save
          render json: TransactionSerializer.render(transaction),
                 status: :created
        else
          render json: { errors: transaction.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def transaction_params
        params.permit(:source_wallet_id, :target_wallet_id, :amount, :notes)
      end
    end
  end
end
