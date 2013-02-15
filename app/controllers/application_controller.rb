class ApplicationController < ActionController::Base
  protect_from_forgery

  # Custom redirect path after successful sign in
  def after_sign_in_path_for(resource)
    tweets_path
  end
end
