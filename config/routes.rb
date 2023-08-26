Rails.application.routes.draw do
  devise_for :users
  mount BaseApi => '/'
end
