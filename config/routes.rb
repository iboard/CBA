Cba::Application.routes.draw do

  match '/p/:permalink' => 'pages#permalinked', :as => 'permalink_path'
  match '/edit_comment/:type/:commentable_id/:comment_id' => 'comments#edit', :as => 'edit_comment'
  match '/delete_comment/:type/:commentable_id/:comment_id' => 'comments#destroy', :as => 'delete_comment'
  resources :pages do
    member do
      get :delete_cover_picture
    end
    resources :comments
  end

  match '/registrations' => 'users#index', :as => 'registrations'
  
  devise_for :users, :controllers => { :registrations => 'registrations' }
  resources :users, :only => :show do
    member do
      get :crop_avatar
      put :crop_avatar
      get :edit_roles
      put :update_roles
    end
  end
  
  match '/auth/:provider/callback' => 'authentications#create'
  resources :authentications, :only => [:index,:create,:destroy]
  
  root :to => 'home#index'

end
