class BaseApi < Grape::API
  format :json

  prefix 'api'

  helpers do
    def current_user
      @current_user ||= find_user_from_token || env['warden'].user
    end

    def find_user_from_token
      token = headers['Authorization']&.split&.last
      return nil unless token
      User.find_by(authentication_token: token)
    end

    def authenticate!
      error!('Unauthorized. Invalid or expired token.', 401) unless current_user
    end
  end

  mount UserApi
end
