Rails.application.routes.draw do
  resources :posts, except: %w(edit update destroy)
  
  root to: 'posts#new'
  get '/:permlink', to: 'posts#show'
end
