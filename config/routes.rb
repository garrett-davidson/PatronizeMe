Rails.application.routes.draw do
  get 'explore', to: 'projects#explore'
  get 'search', to: 'projects#search'
  get 'profile', to: 'profiles#profile'
  get 'profile/index', to: 'profiles#index', as: "users"
  get 'profile/settings', to: 'profiles#settings'
  get 'profile/githubprojects', to: 'profiles#github_projects'
  get 'profile/projectexists', to: 'profiles#project_exists'
  get 'profile/:id', to: 'profiles#user', as: "user"

  post 'projects/:id/issues/refresh', to: 'projects#refresh_issues'

  patch 'profile/:id', to: 'profiles#updatesettings'

  resources :charges

  resources :projects
  get 'home/index'

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks", :registrations => 'users/registrations' }
  resources :home
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'home#index'
end
