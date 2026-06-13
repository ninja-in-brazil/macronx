module Api
  module V1
    class BaseController < ActionController::API
      include Apipie::DSL::Controller

      before_action :authenticate_api_token!

      private

      def authenticate_api_token!
        token = request.headers['Authorization']&.delete_prefix('Bearer ')
        @current_api_user = User.find_by_api_token(token) if token.present?
        render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_api_user
      end
    end
  end
end
