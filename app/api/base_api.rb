class BaseApi < Grape::API
  format :json

  prefix 'api'
  mount UserApi
end
