Cba::Application.routes.draw do

  # Switch locales
  match 'switch_lcoale/:locale' => "home#set_locale", :as => 'switch_locale'

  # Comments
  resources :comments

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
  
  
  # PAGES
  match '/p/:permalink' => 'pages#permalinked', :as => 'permalinked'
  resources :pages do
    member do
      get :delete_cover_picture
    end
    resources :comments
  end

  # USERS
  match '/registrations' => 'users#index', :as => 'registrations'
  
  devise_for :users, :controllers => { :registrations => 'registrations' }
  resources :users, :only => [:show,:destroy] do
    member do
      get :crop_avatar
      put :crop_avatar
      get :edit_role
      put :update_role
    end
  end
  
  # AUTHENTICATIONS
  match '/auth/:provider/callback' => 'authentications#create'
  resources :authentications, :only => [:index,:create,:destroy]
  match '/auth/failure' => 'authentications#auth_failure'
  
  # ROOT
  root :to => 'home#index'

end
