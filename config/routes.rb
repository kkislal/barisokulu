Rails.application.routes.draw do

  root :to => 'main#index'

  post 'main/attempt_login'
  post 'main/new_user'
  post 'main/add_comment'

  get 'main/login'
  get 'main/logout'
  get 'main/register'
  get 'main/delete_comment'
  get 'main/about'
  get 'main/contact'

  mount Blazer::Engine, at: "blazer"

  resources :events  do
    collection do
      get :list
      get :search
    end
  end

  resources :posts  do
    collection do
      get :list
      get :search
    end
  end

  resources :galleries do
    member do
      delete :delete_image
    end
  end

  resources :blog_categories
  resources :users
  resources :event_types
  resources :event_categories

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
