class BaseApi < Grape::API
  format :json

  prefix 'api'
  mount UserApi

  before do
    authenticate_user!
  end
end
