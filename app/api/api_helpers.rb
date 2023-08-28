# module AuthHelpers
#   def current_user
#     decoder = Warden::JWTAuth::UserDecoder.new

#     puts decoder
#     decoder.call(token, :user, nil)
#   rescue
#     unauthorized_error!
#   end

#   def token
#     auth = headers['Authorization'].to_s
#     auth.split.last
#   end
# end
