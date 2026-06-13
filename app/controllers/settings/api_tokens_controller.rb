module Settings
  class ApiTokensController < ApplicationController
    def show; end

    def update
      current_user.regenerate_api_token!
      redirect_to settings_api_token_path, notice: 'API token regenerated.'
    end
  end
end
