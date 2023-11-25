module Api
  module V1
    class GroupController < ApplicationController
      def show
        transaction = Transaction.find_by!(id: params[:id])
        render json: TransactionSerializer.render(transaction)
      end

      def create
        transaction = Transaction.new(group_params)

        if transaction.save
          render json: TransactionSerializer.render(transaction),
                 status: :created
        else
          render json: { errors: transaction.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update; end

      private

      def group_params
        params.permit(:source_wallet_id, :target_wallet_id, :amount, :notes)
      end
    end
  end
end
