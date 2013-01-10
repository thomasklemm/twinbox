Twinbox::Application.routes.draw do
  # Sidekiq Web Interface
  # TODO: Authenticate to access
  require 'sidekiq/web'
  mount Sidekiq::Web, at: 'admin/sidekiq', as: :sidekiq

  # Static Pages
  get ':id' => 'high_voltage/pages#show', as: :static

  # Root
  root to: 'high_voltage/pages#show', id: 'index'
end
