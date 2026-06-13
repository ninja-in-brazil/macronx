module Settings
  class ApiTokensController < ApplicationController
    def show; end

    def update
      if current_user.regenerate_api_token
        session[:new_api_token] = current_user.api_token
        redirect_to settings_api_token_path, notice: "New API token generated. Copy it now — it will not be shown again."
      else
        redirect_to settings_api_token_path, alert: "Failed to regenerate token. Please try again."
      end
    end
  end
end
