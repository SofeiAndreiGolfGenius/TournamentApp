# frozen_string_literal: true

Rails.application.routes.draw do
  get 'messages/create'
  get 'messages/destroy'
  root 'static_pages#home'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :sessions, only: %i[new create destroy] do
    get 'login', action: 'create', as: 'login'
  end
  resources :users do
    member do
      get 'leave', action: 'leave_team', as: 'leave'
      get 'kick_out', action: 'kick_out_of_team', as: 'kick_out'
      get :received_friend_requests
      get :friends
    end
    collection do
      get :search
    end
  end
  resources :teams do
    collection do
      get 'create', action: 'new', as: 'create'
      get :search
    end
    member do
      delete 'delete', action: 'destroy', as: 'delete'
      get :invited_to_team
    end
  end
  resources :team_invitations, only: [:destroy] do
    member do
      get :ask_to_join
      get :invite_to
      get 'accept_invitation/:team_id', action: 'accept_invitation', as: 'accept'
      get 'reject_invitation/:team_id', action: 'reject_invitation', as: 'reject'
      get 'approve_invitation/:user_id', action: 'approve_invitation', as: 'approve'
      get 'deny_invitation/:user_id', action: 'deny_invitation', as: 'deny'
    end
  end
  resources :tournaments do
    collection do
      get 'create', action: 'new', as: 'create'
      get :search
    end
    member do
      get :start
    end
  end
  resources :tournament_participating_teams, only: %i[create destroy]
  resources :tournament_participating_users, only: %i[create destroy]
  resources :matches, only: %i[update] do
    member do
      get :declare_winner
      get :reset_score
    end
  end
  resources :friend_requests, only: %i[create destroy] do
    member do
      get 'accept/:request_id', action: 'accept', as: 'accept'
      get 'reject/:request_id', action: 'reject', as: 'reject'
    end
  end
  resources :friendships, only: [:destroy] do
    member do
      get :chatroom
    end
  end
  resources :messages, only: %i[create destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
