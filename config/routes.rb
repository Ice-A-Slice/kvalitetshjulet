Kvalitetshjulet::Application.routes.draw do

  get "user_workgroups/create"
  get "user_workgroups/destroy"
  get "active_teachers/new"
  get "active_teachers/destroy"
  get "active_principals/new"
  get "schools_users/new"

  #-----> SCOPE FOR GOOGLE LOGIN -----> DO NOT EDIT!
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'
  resources :sessions, only: [:create, :destroy]
  get "sessions", to: "sessions#index"
  #---------------------------------------------->

  resources :active_principals
  resources :high_lights
  resources :school_users
  resources :active_teachers
  resources :events
  resources :event_types, :path => "event-types"
  get '/event-types/remove/:id', :to => 'event_types#remove', :as => :remove_event_type
  resources :schools do
    resources :schools_users
    resources :active_principals
    resources :active_teachers
    get 'add' => 'schools_users#new'
    get 'add_teacher' => 'schools#add_teacher'
    get 'add_principal' => 'schools#add_principal'
    get 'destroy_image' => 'schools#destroy_image'

    scope '/principal', :module => 'principal', :as => 'principal' do
      resources :users
    end
    scope '/teacher', :module => 'teacher', :as => 'teacher' do
      resources :users
      get 'schools' => 'users#school'
    end
  end

  resources :user_workgroups

  resources :workgroups do
    get 'add_user' => 'workgroups#add_user'
  end

  # Routes for user scopes
  get '/users/:id', :to => 'users#show', :as => :user

  scope '/admin', :module => 'admin', :as => 'admin' do
      resources :users
  end

  scope '/juror', :module => 'juror', :as => 'juror' do
      resources :users
  end

  scope '/principal', :module => 'principal', :as => 'principal' do
      resources :users
  end

  scope '/teacher', :module => 'teacher', :as => 'teacher' do
      resources :users do
        collection { post :import }
      get 'schools' => 'users#school'
    end
  end

  get "sessions/test", to: "sessions#test"
  get "sessions/events", to: "sessions#events"
  get "sessions/show_week_events/:id/:type", to: "sessions#show_week_events"
  get "sessions/edit_week_event/:id(/:type)", to: "sessions#edit_week_event"
  get "sessions/new_week_event/:id/:type", to: "sessions#new_week_event"
  get "sessions/user/:id", to: "sessions#user"
  get "sessions/changeyear/:year", to: "sessions#set_selected_year"

  get "sessions/show_high_lights/:id", to: "sessions#show_high_lights"
  get "sessions/new_high_lights/:id", to: "sessions#new_high_lights"
  get "sessions/edit_high_lights/:id", to: "sessions#edit_high_lights"
  get "sessions/show_specific_highlights/:id", to: "sessions#show_specific_highlights"

  get "sessions/delete_file/:id", to: "sessions#delete_file"

  root 'sessions#index'

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
