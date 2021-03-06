Daitss::Application.routes.draw do
  get "packages/new"
  get "packages/submit"

  resources :accounts
  resources :projects
  resources :users
  resources :packages, only: [:index, :submit]
  resources :sessions, only: [:new, :create, :destroy]
  resource :workspace, :controller => :workspace, except: [:show]
  resource :stashspace, :controller => :stashspace, except: [:show]
  resources :operators, :controller => "users" # single table inheritance, operator is a kind of user.
  resources :contacts, :controller => "users" # single table inheritance, contact is a kind of user.

  root to: 'sessions#new'
  match '/dashboard', to: 'main#dashboard'
  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete    
  match '/help',  to: 'main#help'
  match '/admin' => 'main#admin'
  match '/log', to: 'main#log'
  match '/log_message', to: 'main#log_message'  
  match '/edit_password', to: 'users#edit_password'  
  match '/update_password', to: 'users#update_password'  
  match '/submit', to: 'packages#submit'
  match '/upload', to: 'packages#upload'
  match '/submit_request', to: 'packages#submit_request'
  match '/workspace', to: 'workspace#workspace'
  match '/update', to: 'workspace#update'
  match '/stashspace', to: 'stashspace#stashspace'
  match '/stashspace/:id', to: 'stashspace#delete'
  
  get '/packages/:id', to: 'packages#show', :as => 'package'
  get '/workspace/:id', to: 'workspace#show', :as => 'wip'
  get 'main/select_account', :as => 'select_account'
  get 'packages/select_package_account', :as => 'select_package_account'
  
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
