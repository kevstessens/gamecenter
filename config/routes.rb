Rails.application.routes.draw do

  match '/achievements/activate/:id', to: 'achievements#activate', via: [:get, :post], as: "achievements_activate"
  resources :achievements

  resources :games

  devise_for :game_owners, :controllers => {:registrations => "registrations"}

  resources :game_owners

  resources :users

  match '/game_info', to: 'games#game_info', via: [:get]
  match 'app/:game_id/user/:user_id/achievement/:achievement_id/:signature', to: 'rest#persist_achievement', via: [:get, :post]
  match 'app/:game_id/user/:user_id/achievements/:signature', to: 'rest#user_achievements', via: [:get, :post]

  match 'app/:game_id/user/:user_id/:signature', to: 'public_views#index', via: [:get, :post]
  match 'app/:game_id/user/:user_id/friends/:friends/:signature', to: 'public_views#index_friends', via: [:get, :post]
  match 'app/error', to: 'public_views#error', via: [:get, :post]
  match 'app/no_gamer', to: 'public_views#no_gamer', via: [:get, :post]



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'game_owners#index'

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

  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]
end
