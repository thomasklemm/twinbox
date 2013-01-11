Twinbox::Application.routes.draw do
  ##
  # Users
  devise_for :users,
    path_names: {sign_in: 'login', sign_out: 'logout', sign_up: 'signup'},
    path: '' # removes '/users/' path prefix

  ##
  # Omniauth to authorize Twitter accounts
  match 'auth/twitter/setup' => 'omniauth#setup'
  match 'auth/twitter/callback' => 'omniauth#callback'
  match 'auth/failure' => redirect('/')


  # Sidekiq Web Interface
  # TODO: Authenticate to access
  require 'sidekiq/web'
  mount Sidekiq::Web, at: 'admin/sidekiq', as: :sidekiq

  # Static Pages
  get ':id' => 'high_voltage/pages#show', as: :static

  # Root
  root to: 'high_voltage/pages#show', id: 'index'
end
