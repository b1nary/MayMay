Rails.application.routes.draw do

  get 'api' => "info#api"
  get 'about' => "info#about"
  get 'no' => "info#no"
  get 'terms-of-use' => "info#terms-of-use"
  get 'privacy-policy' => "info#privacy-policy"

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: "home#index"

  devise_for  :users, :skip => [:sessions],
              :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  as :user do
    get 'login' => 'devise/sessions#new', :as => :new_user_session
    post 'login' => 'devise/sessions#create', :as => :user_session
    get 'register' => 'devise/registrations#new', :as => :register_user_session
    post 'register' => 'devise/registrations#create', :as => :register_session
    get 'logout' => 'devise/sessions#destroy', :as => :destroy_user_session
    #delete 'logout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  get 'top_users' => 'home#top_users', :as => "top_users"

  # Memes list & Generator
  get '/memes' => 'meme#list', :as => "memes"
  get '/memes/templates' => 'home#templates', :as => "templates"
  get '/memes/generator/:meme' => 'home#generator', :as => "generator"
  get '/memes/generator' => 'home#generator', :as => "generator_random"

  get '/memes/:page' => 'meme#list', :as => "memes_with_page"
  get '/memes/:meme/:page' => 'meme#list', :as => "memes_with_meme_and_page"

  # Meme info
  get '/info/:hex' => 'meme#view_image', :as => "view_meme"

  # User overview
  get '/user/:username' => 'home#user', :as => "view_user"

  # User change name action
  get '/change_name' => "user_actions#change_name", :as => "change_name"
  get '/change_name_action/:username' => "user_actions#change_name_action", :as => "change_name_action"

  # Delete maymay action
  get '/delete_maymay/:meme' => "home#remove_meme", :as => "delete_maymay"

  # Admin dashboard
  get '/admdash/' => "admin_dashboard#index", :as => "admin_dashboard"
  get '/admdash/upload/' => "admin_dashboard#upload", :as => "admin_dashboard_upload"
  post '/admdash/upload/' => "admin_dashboard#upload_action", :as => "admin_dashboard_upload_post"
  get '/admdash/picdumps/' => "admin_dashboard#picdumps", :as => "admin_dashboard_picdumps"
  get '/admdash/delete_picdump_image/:image_id' => "admin_dashboard#delete_picdump_image", :as => "delete_picdump_image"

  # Picdumps
  # get '/picdumps' => "picdumps#index", :as => "picdumps"
  # get '/picdumps/:category' => "picdumps#index", :as => "picdump_category"
  # get '/picdump/:title' => "picdumps#view", :as => "picdump"

  # Meme catch all
  get ':meme/:top/:bottom' => 'image#check', :as => "image_generator_top_bottom"
  get ':meme/:top' => 'image#check', :as => "image_generator_top"

  match '/404', to: 'errors#e404', via: :all
  match '/422', to: 'errors#e422', via: :all
  match '/500', to: 'errors#e500', via: :all
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
