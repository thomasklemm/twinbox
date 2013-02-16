Twinbox::Application.routes.draw do
  get "twitter_accounts/index"

  get "twitter_accounts/show"

  # User authentication
  devise_for :users,
    path_names: {sign_in: 'login', sign_out: 'logout', sign_up: 'signup'}

  # Custom paths for user auth
  devise_scope :user do
    get 'login',     to: 'devise/sessions#new',      as: :new_user_session
    delete 'logout', to: 'devise/sessions#destroy',  as: :destroy_user_session
    get 'signup',    to: 'devise/registrations#new', as: :new_user_registration
  end

  # Omniauth to authorize Twitter accounts
  #  There is a hidden 'auth/twitter' path too that requests can be directed to
  #  when trying to authorize a Twitter account with this application
  match 'auth/twitter/callback' => 'omniauth#twitter'
  match 'auth/failure'          => 'omniauth#failure'

  # Tweets
  resources :tweets, only: [:index, :show] do
    member do
      put :open  # open_issue workflow event
      put :close # close workflow event
    end
  end

  # Owned account
  # Allow account owner to modify account settings
  resource :account, only: [:show, :edit, :update, :destroy] do
    resource :plan # TODO: Restrict actions
  end

  # Project for each account member
  resource :project, only: :show do
    resources :twitter_accounts, only: [:index, :show, :new]
  end

  # Static Pages
  # TODO: maybe restrict with some condition to only route requests
  #       to known pages. Else 404 is rendered in production.
  get ':id' => 'pages#show', as: :static

  # Root
  root to: 'pages#show', id: 'home'

  # Fallback (Redirect to home instead of 404)
  # match '*path' => redirect('/')

  # resources :accounts, only: [:index, :edit, :update, :destroy] do
  #   resource :billing
  #   resource :plan
  #   resources :projects
  #   resources :memberships, only: [:index, :edit, :update, :destroy]
  #   resources :invitations, only: [:show, :update, :new, :create]
  # end


  # # Settings
  # scope 'settings' do
  #   # Twitter accounts
  #   resources :twitter_accounts, only: :index do
  #     post 'track_mentions', on: :member
  #     post 'untrack_mentions', on: :member
  #   end

  #   # Queries
  #   resources :queries, only: [:index, :create, :destroy]
  # end

  # # API
  # scope ':api' do
  #   # Tweets
  #   resources :tweets
  # end
end
