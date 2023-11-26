module Api
  module V1
    class StocksController < ApplicationController
      def index
        stocks = Stock.all

        render json: StockSerializer.render(stocks)
      end

      def show
        group = Stock.find(params[:id])
        render json: StockSerializer.render(group)
      end

      def create
        ActiveRecord::Base.transaction do
          @stock = Stock.new(stock_params)
          @stock.save!
        end

        render json: StockSerializer.render(@stock),
               status: :created
      rescue StandardError
        render json: { errors: @stock.errors.full_messages }, status: :unprocessable_entity
      end

      def update
        stock = Stock.find(params[:id])

        if stock.update(stock_params)
          render json: StockSerializer.render(stock)
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
