Rails.application.routes.draw do
  resources :users
  resources :alerts do 
    member do 
      delete :delete_by_name
      get :index
    end
  end
  delete "alerts" => "alerts#delete_by_name"
  get "alerts" => "alerts#index"
  # devise_for :users, controllers: {
  #   sessions: 'users/sessions'
  # }
  # resources :users do
  #   member do
  #     post :fetch_alerts
  #   end
  # end
  # post "users/:id/fetch_alerts" => "users#fetch_alerts"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root to: "home#index"
end
