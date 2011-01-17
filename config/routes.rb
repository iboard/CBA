Cba::Application.routes.draw do

  match '/p/:permalink' => 'pages#permalinked', :as => 'permalink_path'
  resources :pages

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
