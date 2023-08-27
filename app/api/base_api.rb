class BaseApi < Grape::API
  format :json

  prefix 'api'


  helpers do
    def current_user
      @current_user ||= env['warden'].user
    end

    def authenticate!
      error!('Unauthorized. Invalid or expired token.', 401) unless current_user
    end
  end

  mount UserApi
end
