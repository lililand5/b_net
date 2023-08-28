class PostsApi < BaseApi
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
      posts = Post.joins(:user).merge(current_user.followees(User)).order(created_at: :desc).map do |post|
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
      excluded_user_ids = [current_user.id] + current_user.followees(User).pluck(:id)
      all_posts = Post.where.not(user_id: excluded_user_ids)
                      .order(created_at: :desc)
                      .includes(:user)
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
