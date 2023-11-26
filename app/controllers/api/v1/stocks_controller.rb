module Api
  module V1
    class StocksController < ApplicationController
      def index
        stocks = paginate(Stock.all)

        render json: render_collection(stocks)
      end

      def show
        stock = Stock.find(params[:id])
        render json: render_record(stock)
      end

      def create
        ActiveRecord::Base.transaction do
          @stock = Stock.new(stock_params)
          @stock.save!
        end

        render json: render_record(@stock),
               status: :created
      rescue StandardError
        render json: { errors: @stock.errors.full_messages }, status: :unprocessable_entity
      end

      def update
        stock = Stock.find(params[:id])

        if stock.update(stock_params)
          render json: render_record(stock)
        else
          render json: { errors: stock.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def stock_params
        params.permit(:name, :code)
      end
    end
  end
end
