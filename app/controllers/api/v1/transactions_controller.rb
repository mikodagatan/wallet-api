module Api
  module V1
    class TransactionsController < ApplicationController
      def index; end

      def create
        transaction = Transaction.new(transaction_params)

        if transaction.save
          render json: transaction, status: :created
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
