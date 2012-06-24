ConferenceManager2::Application.routes.draw do

   # get "store/index" # Not sure what this is or how it got here....
  #  get "store/new"
  #  get "store/create"
  #  get "store/destroy"

  root :to => 'main_landing#index'

  resources :users, :conference_numbers, :bookings
  
  # My Routes
  get "my" => "bookings#my_index" # Allow easy reference to "My Bookings"
  get "profile" => "users#edit" # Allow easy reference to "My Profile"
  get "test" => "application#test" # My Testing Harness
  
  # match "profile" => "users#edit"

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  get "sign_up" => "users#new", :as => "sign_up"
  get "sign_in" => "sessions#new"
  post "sign_in" => "sessions#create"
  get "sign_out"=> "sessions#destroy"
  
  get "clear_booking_steps" => "sessions#clear_booking_steps"
  
  get "booking/check_availability" => "bookings#check_availability" # This route is intentionally defined as BOOKING (instead of 'bookings'). Althrough I prefer the idea of /bookings/check_availability, I cannot work out how to separate it from the /bookings/:ID/edit.

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
