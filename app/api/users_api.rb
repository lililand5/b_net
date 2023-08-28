class UsersApi < BaseApi
  before do
    authenticate!
  end

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

    get 'my_posts' do
      if current_user.posts.empty?
        posts = []
      end
      posts = current_user.posts.order(created_at: :desc).map do |post|
        {
          id: post.id,
          title: post.title,
          content: post.content,
          created_at: post.created_at,
          updated_at: post.updated_at
        }
      end
      { my_posts: posts }
    end

    get 'feed' do
      subscriptions_posts = Post.joins(:user).merge(current_user.followees(User))
      all_posts = (subscriptions_posts.to_a).sort_by(&:created_at).reverse
      posts = all_posts.map do |post|
        {
          id: post.id,
          title: post.title,
          content: post.content,
          created_at: post.created_at,
          updated_at: post.updated_at,
          user: {
            id: post.user.id,
            email: post.user.email
          }
        }
      end

      { feed: posts }
    end

    get 'global_posts' do
      current_user_posts = current_user.posts.pluck(:id)
      subscribed_user_ids = current_user.followees(User).pluck(:id)

      all_posts = Post.where.not(user_id: [current_user.id] + subscribed_user_ids)
                      .order(created_at: :desc)

      posts = all_posts.map do |post|
        {
          id: post.id,
          title: post.title,
          content: post.content,
          created_at: post.created_at,
          updated_at: post.updated_at,
          user: {
            id: post.user.id,
            email: post.user.email
          }
        }
      end

      { all_posts: posts }
    end

    post 'create_post' do
      unless params[:title] && params[:content]
        error!('Title and content are required.', 400)
      end

      post = current_user.posts.create(
        title: params[:title],
        content: params[:content]
      )

      if post.persisted?
        {
          id: post.id,
          title: post.title,
          content: post.content,
          created_at: post.created_at,
          updated_at: post.updated_at,
          user: {
            id: post.user.id,
            email: post.user.email
          }
        }
      else
        error!(post.errors.full_messages.join(', '), 422)
      end
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
