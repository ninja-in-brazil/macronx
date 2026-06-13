class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_secure_token :api_token

  alias_method :regenerate_api_token!, :regenerate_api_token
end
