Rails.application.routes.draw do
  namespace :api do
    get 'hello', to: 'hello#index'
  end
end
