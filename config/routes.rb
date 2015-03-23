Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root 'session#new'
  get 'session/new'
  get 'tours/disconnect_device' => "tours#disconnect_device"
  get 'tours/change_device' => "tours#change_device"

  post 'session/create'
  get 'tours/list_users/:id' => "tours#list_users", as: :list_user

  delete 'session/destroy', as: :sign_out
  get 'sign_out' => "session#destroy"

  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end

  concern :searching do
    get 'search', action: :search, on: :collection, as: :search
  end
  post 'tours/add_tourguide/:tour_id' =>"tours#add_tourguide", as: :add_tourguide
  post 'tours/add_traveller/:tour_id' =>"tours#add_traveller", as: :add_traveller

  get 'tours/:tour_id/traveller/:traveller_id' =>"tours#remove_traveller",as: :remove_traveller
  get 'tours/:tour_id/tourguide/:tourguide_id' =>"tours#remove_tourguide", as: :remove_tourguide
  resources :companies

  resources :feedbacks, only: [:index,:show]

  resources :tourguides

  resources :travellers

  resources :devices

  resources :tours do
    resources :travellers, only: [:new,:create]   
    resources :tourguides ,only: [:new]
  end
  resources :users, :concerns => :paginatable do
    get 'edit_password', on: :member
    post 'update_password', on: :member
    get 'company_profile'
  end

  root to:'session#new', as: :sign_in
  
  get "api/devices" => "api/devices#show"
  post "api/devices/create" =>"api/devices#create"
  get "api/users/list" => "api/users#list"
  post "api/users/push" => "api/users#push"
  post "api/users/update_position" => "api/users#update_position"
  post "api/users/feedback" => "api/users#feedback"
  namespace :api do
    resource :users , only: :show
    resource :devices
    
  end


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
