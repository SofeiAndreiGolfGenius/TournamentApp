# frozen_string_literal: true

Rails.application.routes.draw do
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get '/create_team', to: 'teams#new'
  root 'static_pages#home'
  resources :users do
    member do
      get 'join/:team_id', :action => 'join_team', :as => 'join'
      get 'leave', :action => 'leave_team', :as => 'leave'
      get 'kick_out', :action => 'kick_out_of_team', :as => 'kick_out'
    end
  end
  resources :teams
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
