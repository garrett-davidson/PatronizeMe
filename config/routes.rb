Rails.application.routes.draw do
  get 'explore', to: 'projects#explore'
  get 'search', to: 'projects#search'

  resources :projects
  get 'home/index'

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
   resources :home
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'home#index'
end
