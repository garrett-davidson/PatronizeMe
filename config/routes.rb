Rails.application.routes.draw do
  get 'explore', to: 'projects#explore'
  get 'search', to: 'projects#search'
  get 'profile', to: 'profiles#show'
  get 'profiles/:id', to: 'profiles#show'

  resources :projects
  get 'home/index'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'home#index'
end
