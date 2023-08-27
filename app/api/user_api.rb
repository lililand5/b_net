class UserApi < BaseApi
  before do
    authenticate!
  end

  resource :users do
    get do
      { message: "Hello from User API!" }
    end
  end
end
