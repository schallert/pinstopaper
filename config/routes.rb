Pinstopaper::Application.routes.draw do
  root :to => 'static_pages#home'

  as :user do
    get 'login'   => 'devise/sessions#new',      :as => :new_user_session
    post 'login'  => 'devise/sessions#create',   :as => :user_session
    get 'logout'  => 'devise/sessions#destroy',  :as => :destroy_user_session
    get 'account' => 'users/registrations#edit', :as => :edit_user_registration
  end

  devise_for :users, :skip => [:sessions],
    :controllers => { :registrations => 'users/registrations' }

  get 'posts'          => 'posts#index'
  get 'posts/unread'   => 'posts#unread',   :as => :unread_posts
  get 'posts/import'   => 'posts#import',   :as => :import_posts
  get 'posts/sync_all' => 'posts#sync_all', :as => :sync_all_posts
  get 'posts/:id'      => 'posts#show',     :as => :post
  get 'posts/:id/sync' => 'posts#sync',     :as => :sync_post
end
