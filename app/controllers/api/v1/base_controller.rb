module Api
  module V1
    class BaseController < ActionController::API
      before_action :authenticate_api_token!

      private

      def authenticate_api_token!
        token = request.headers['Authorization']&.delete_prefix('Bearer ')
        expected = Rails.application.credentials.api_token

        return if expected.present? && ActiveSupport::SecurityUtils.secure_compare(token.to_s, expected)

        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end
  end
end
