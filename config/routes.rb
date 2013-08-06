Pinstopaper::Application.routes.draw do
  root :to => 'static_pages#home'

  devise_for :users, :skip => [:sessions]
  as :user do
    get 'login' => 'devise/sessions#new', :as => :new_user_session
    post 'login' => 'devise/sessions#create', :as => :user_session
    get 'logout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  get 'posts'          => 'posts#index'
  get 'posts/:id'      => 'posts#show'
  get 'posts/:id/sync' => 'posts#sync'
end
