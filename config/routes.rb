UserInterface::Application.routes.draw do
  resources :users

  root to: 'users#index'

  if Rails.env.development? or Rails.env.test?
    post '/users/reset', to: 'users#reset'
  end
end
