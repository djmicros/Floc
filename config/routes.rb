Floc::Application.routes.draw do
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :locations
  
  
  root to: 'static_pages#home'

  get 'tags/:search_tag', to: 'locations#index', as: :search_tag
  get 'tags/:tag', to: 'locations#index', as: :tag
  

  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'
  
  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
  
  match '/location/new',  to: 'locations#new'
  match '/location/:id',  to: 'locations#show'

  get '/location/:id/edit', to: 'locations#edit'
  get '/location/:id/delete', to: 'locations#destroy'
  
  get '/photo/:id/delete', to: 'locations#delete_photo'
	
  match '/location',  to: 'locations#index'

  match '/users/:id/locations', to: 'locations#user_locations', as: :user_locations

  match 'auth/:provider/callback', to: 'sessions#create_fb'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'
  
  # Mobile app routes
  
  match 'app_signin', to: 'sessions#app_create'
  match 'token_signin', to: 'sessions#token_create'
  match 'app_signup', to: 'users#app_create'
  match 'app_add_location', to: 'locations#app_create'
  match 'app_search', to: 'locations#app_search'
  match 'app_get_location', to: 'locations#app_get_location'
  match 'app_get_user_locations', to: 'users#app_get_user_locations'
  match 'app_get_user', to: 'users#app_get_user'
  match 'app_update_user', to: 'users#app_update_user'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
