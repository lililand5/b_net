class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def logged_in
    render json: { logged_in: !current_user.nil? }
  end
end
