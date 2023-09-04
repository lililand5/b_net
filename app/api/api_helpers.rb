module ApiHelpers
  def authenticate!
    authorization_header = headers['Authorization']
    if authorization_header.nil?
      error!('Unauthorized', 401)
      return
    end

    token = authorization_header.split(' ').last
    error!('Unauthorized', 401) unless User.find_by(authentication_token: token)
  end
end
