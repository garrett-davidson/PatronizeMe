Rails.application.routes.draw do
  get 'explore', to: 'projects#explore'
  get 'search', to: 'projects#search'
  get 'profile', to: 'profiles#show'
  get 'profile/addfunds', to: 'profiles#addfunds'
  get 'profile/:id', to: 'profiles#user', as: "user"
  get 'profileindex', to: 'profiles#index', as: "users"

  resources :projects
  get 'home/index'

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks", :registrations => "callbacks" }
  resources :home
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'home#index'
end
