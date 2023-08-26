class UserApi < BaseApi
  resource :users do
    get do
      { message: "Hello from User API!" }
    end
  end
end
