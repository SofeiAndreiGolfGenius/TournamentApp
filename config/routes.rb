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
  get '/create_tournament', to: 'tournaments#new'
  root 'static_pages#home'
  resources :users do
    member do
      get 'leave', action: 'leave_team', as: 'leave'
      get 'kick_out', action: 'kick_out_of_team', as: 'kick_out'
      get :team_invitations
    end
  end
  resources :teams do
    member do
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
  resources :tournaments
  resources :tournament_participating_teams, only: %i[create destroy]
  resources :tournament_participating_users, only: %i[create destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
