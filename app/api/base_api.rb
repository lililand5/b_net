class BaseApi < Grape::API
  format :json

  prefix 'api'
  mount UserApi

  before do
    error!('Unauthorized', 401) unless current_user
  end

  helpers do
    def current_user
      @current_user ||= env['warden'].authenticate(scope: :user)
    end
  end
end
