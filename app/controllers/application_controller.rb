class ApplicationController < ActionController::Base
  protect_from_forgery

  # Redirect to tweets#index on successful login
  def after_sign_in_path_for(resource)
    tweets_path
  end
end
