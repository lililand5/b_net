class UserApi < BaseApi
  # before do
  #   authenticate!
  # end

  resource :users do
    get do
      { hi: "Hello from User API!" }
    end
  end
end
