class PostsApi < BaseApi
  before do
    authenticate!
  end

  resource :posts do
    get 'my' do
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

    post 'create' do
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
  end
end
