module Api
  module V1
    class TransactionsController < ApplicationController
      def index
        transactions = paginate(@current_user.all_transactions)

        render json: render_collection(transactions)
      end

      def show
        transaction = Transaction.find(params[:id])
        render json: render_record(transaction)
      end

      def create
        ActiveRecord::Base.transaction do
          @transaction = Transaction.new(transaction_params)
          @transaction.save!
        end

        render json: render_record(@transaction),
               status: :created
      rescue StandardError
        render json: { errors: @transaction.errors.full_messages }, status: :unprocessable_entity
      end

      private

      def transaction_params
        params.permit(:source_wallet_id, :target_wallet_id, :amount, :notes)
      end
    end
  end
end
