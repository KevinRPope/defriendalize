Defriend::Application.routes.draw do
  get "defriend/index"
  get "session/create"
  get "session/destroy"
  #get "users/exclude"
  match 'users/profile' => 'users#show', :as => :user_path
  match 'users/unsubscribe/:uid' => 'users#unsubscribe#uid', :as => :unsubscribe
  match 'users/resubscribe/:id' => 'users#resubscribe#id', :as => :resubscribe
  match 'users/delete_account' => 'users#delete_account', :as => :delete_account
  match 'auth/facebook/callback' => "session#create"
  match 'session/deauthorize' => "session#deauthorize"
  match 'auth/failure' => 'session#FAQ'  #change this to a page asking why they said no.
  match 'FAQ' => 'session#FAQ', :as => :faq
  match 'contact_us' => 'session#contact_us', :as => :contact_us
  match 'about_us' => 'session#about_us', :as => :about_us
  match 'privacy_policy' => 'session#privacy_policy', :as => :privacy_policy
  match 'signout' => "session#destroy", :as => :signout
  match 'facebook_signout' => "session#facebook_destroy", :as => :facebook_signout
  match 'destroy_job/:id' => 'application#destroy_job#id', :as => :destroy_job
  match 'session/facebook_login' => 'session#facebook_login', :as => :facebook_login
  match 'defriend/friend_list_update' => 'defriend#friend_list_update', :as => :friend_check
  match 'defriend/update_checkin' => 'defriend#update_checkin'
  match 'defriend/check_my_connections' => 'defriend#check_my_connections', :as => :check_my_connections

  match 'canvas/faq' => 'canvas#faq', :as => :canvas_faq
  match 'canvas/contact_us' => 'canvas#contact_us', :as => :canvas_contact_us
  match 'canvas/about_us' => 'canvas#about_us', :as => :canvas_about_us
  match 'canvas/privacy' => 'canvas#privacy', :as => :canvas_privacy
  match 'canvas/profile' => 'canvas#profile', :as => :canvas_profile
  match 'canvas' => 'canvas#index', :as => :canvas_index
  
  resources :users
  resources :connections  
  resources :canvas
  
  root :to => "defriend#index"
  
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
