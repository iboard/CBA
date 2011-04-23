Cba::Application.routes.draw do

  # Switch locales
  match 'switch_lcoale/:locale' => "home#set_locale", :as => 'switch_locale'

  # Comments
  resources :comments, :except => :show

  # BLOGS
  resources :blogs do
    member do
      get :delete_cover_picture
    end
    resources :postings do
      member do
        get :delete_cover_picture
      end
      resources :comments
    end
  end
  resources :postings, :only => [:show]
  
  
  # PAGES
  match '/p/:permalink' => 'pages#permalinked', :as => 'permalinked'
  resources :pages do
    member do
      get :delete_cover_picture
    end
    resources :comments
  end

  # USERS
  match 'registrations' => 'users#index', :as => 'registrations'
  match 'hide_notification/:id' => 'users#hide_notification', :as => 'hide_notification'
  match 'show_notification/:id' => 'users#show_notification', :as => 'show_notification'
  match 'notifications' => 'users#notifications', :as => 'notifications' 
  match 'profile/:id'   => 'users#show', :as => 'profile'
  
  devise_for :users, :controllers => { :registrations => 'registrations' }
  resources :users, :only => [:show,:destroy] do
    member do
      get :crop_avatar
      put :crop_avatar
      get :edit_role
      put :update_role
      get :send_invitation
    end
  end
  
  # AUTHENTICATIONS
  match '/auth/:provider/callback' => 'authentications#create'
  resources :authentications, :only => [:index,:create,:destroy]
  match '/auth/failure' => 'authentications#auth_failure'
  
  # ROOT
  root :to => 'home#index'

end
