class UserApi < BaseApi
  before do
    authenticate!
  end

  resource :users do
    get do
      { hi: "Hello from User API!" }
    end

    get 'followers' do
      followers = current_user.followers(User)
      { followers: followers.map(&:id) }
    end

    get 'subscriptions' do
      subscriptions = current_user.followees(User)
      { subscriptions: subscriptions.map(&:id) }
    end

    get 'profile' do
      user = current_user
      {
        id: user.id,
        email: user.email,
        authentication_token: user.authentication_token,
        sign_in_count: user.sign_in_count
      }
    end
  end
end
