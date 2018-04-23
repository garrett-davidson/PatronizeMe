Rails.application.routes.draw do
  get 'explore', to: 'projects#explore'
  get 'search', to: 'projects#search'
  get 'profile', to: 'profiles#profile'
  get 'profile/index', to: 'profiles#index', as: "users"
  get 'profile/settings', to: 'profiles#settings'
  get 'profile/githubprojects', to: 'profiles#github_projects'
  get 'profile/projectexists', to: 'profiles#project_exists'
  get 'profile/:id', to: 'profiles#user', as: "user"
  get 'projects/:id/issue/:issue_id', to:'projects#review_issue'

  post 'projects/:id/issues/refresh', to: 'projects#refresh_issues'
  post 'projects/:id/issues/:issue_id/amount/:amount/support', to: 'projects#support_issue'
  post 'projects/:id/issues/:issue_id/cancel', to: 'projects#cancel_support'
  post 'projects/:id/issues/:issue_id/status/:status', to: 'projects#change_issue_status'

  patch 'profile/:id', to: 'profiles#updatesettings'
  
  get 'charges/withdraw' ,to: 'charges#withdraw'
  resources :charges


  resources :projects
  get 'home/index'

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks", :registrations => 'users/registrations' }
  resources :home
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'home#index'
end
