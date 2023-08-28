class UsersApi < BaseApi
  resource :users do
    get do
      users = User.all.map do |user|
        {
          id: user.id,
          email: user.email,
          authentication_token: user.authentication_token,
          sign_in_count: user.sign_in_count
        }
      end
      { users: users }
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

    post ':user_id/follow' do
      user_to_follow = User.find_by(id: params[:user_id])

      if user_to_follow.nil?
        error!('User not found.', 404)
      end

      if current_user.follows?(user_to_follow)
        error!('Already following this user.', 400)
      else
        current_user.follow!(user_to_follow)
        {
          status: 'success',
          message: "Now following user #{user_to_follow.email}."
        }
      end
    end

    delete ':user_id/unfollow' do
      user_to_unfollow = User.find_by(id: params[:user_id])

      if user_to_unfollow.nil?
        error!('User not found.', 404)
      end

      if current_user.follows?(user_to_unfollow)
        current_user.unfollow!(user_to_unfollow)
        {
          status: 'success',
          message: "Unfollowed user #{user_to_unfollow.email}."
        }
      else
        error!('Not following this user.', 400)
      end
    end

  end
end
