class BaseApi < Grape::API
  before { authenticate! }

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
      authorization_header = headers['Authorization']
      if authorization_header.nil?
        error!('Unauthorized', 401)
        return
      end

      token = authorization_header.split(' ').last
      user = User.find_by(authentication_token: token)

      if user.nil?
        error!('Unauthorized. Invalid or expired token.', 401)
      else
        @current_user = user
      end
    end
  end

  mount UsersApi
  mount PostsApi
end
