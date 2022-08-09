# frozen_string_literal: true

Rails.application.routes.draw do
  get 'user/new'
  get 'user/show'
  get 'user/edit'
  get 'user/destroy'
  root 'static_pages#home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
