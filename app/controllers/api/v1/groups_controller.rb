module Api
  module V1
    class GroupsController < ApplicationController
      def show
        group = Group.find(params[:id])
        render json: GroupSerializer.render(group)
      end

      def create
        ActiveRecord::Base.transaction do
          @group = Group.new(group_params)
          @group.save!
        end

        render json: GroupSerializer.render(@group),
               status: :created
      rescue StandardError
        render json: { errors: @group.errors.full_messages }, status: :unprocessable_entity
      end

      def update
        group = Group.find(params[:id])

        if group.update(group_params)
          render json: GroupSerializer.render(group)
        else
          render json: { errors: group.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def group_params
        params.permit(:name)
      end
    end
  end
end
