Twinbox::Application.routes.draw do
  # Users
  devise_for :users,
    path_names: {sign_in: 'login', sign_out: 'logout', sign_up: 'signup'},
    path: '' # removes '/users/' path prefix

  # Omniauth to authorize Twitter accounts
  #  There is a hidden 'auth/twitter' path too that requests can be directed to
  #  when trying to authorize a Twitter account with this application
  match 'auth/twitter/callback' => 'omniauth#twitter'
  match 'auth/failure'          => 'omniauth#failure'

  # Settings
  scope 'settings' do
    # Twitter accounts
    resources :twitter_accounts, only: :index do
      post 'track_mentions', on: :member
      post 'untrack_mentions', on: :member
    end

    # Queries
    resources :queries, only: [:index, :create, :destroy]
  end

  # Tweets
  resources :tweets

  # Sidekiq Web Interface
  #  TODO: Authenticate to access
  require 'sidekiq/web'
  mount Sidekiq::Web, at: 'admin/sidekiq', as: :sidekiq

  # Static Pages
  get ':id' => 'high_voltage/pages#show', as: :static

  # Root
  root to: 'high_voltage/pages#show', id: 'landing'
end
