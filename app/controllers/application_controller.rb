class ApplicationController < ActionController::Base
  protect_from_forgery

  # Custom redirect path after successful sign in
  def after_sign_in_path_for(resource)
    tweets_path
  end

  ##
  # Owned account
  helper_method :ensure_current_owned_account, :current_owned_account, :current_owned_account?

  # Access only to owned account for account owner
  def current_owned_account
    @owned_account ||= current_user.owned_account
  end

  def current_owned_account?
    current_owned_account.present?
  end

  def ensure_current_owned_account
    # TODO: How else can authorization be ensured?
    raise 'Not authorized' unless current_owned_account.present?
  end

  ##
  # Current account
  helper_method :ensure_current_account, :current_account, :current_account?

  def current_account
    @account ||= current_user.account
  end

  def current_account?
    current_account.present?
  end

  def ensure_current_account
    raise 'Not authorized' unless current_account.present?
  end

  ##
  # Current project
  helper_method :ensure_current_project, :current_project, :current_project?

  def current_project
    @project ||= current_account.project
  end

  def current_project?
    current_project.present?
  end

  def ensure_current_project
    raise 'Not authorized' unless current_project.present?
  end
end
