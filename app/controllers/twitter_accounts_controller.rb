class TwitterAccountsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_current_project

  def index
    @twitter_accounts = @project.twitter_accounts
  end

  def show
    @twitter_account = @project.twitter_accounts.find_by(screen_name: params[:id])
  end

  def new
    case params[:scope].to_s
      when 'messages'
        user_session[:twitter_auth_scope] = :messages
        return redirect_to '/auth/twitter?use_authorize=true'
      when 'write'
        user_session[:twitter_auth_scope] = :write
        return redirect_to '/auth/twitter?use_authorize=true&x_auth_access_type=write'
      when 'read'
        user_session[:twitter_auth_scope] = :read
        return redirect_to '/auth/twitter?use_authorize=true&x_auth_access_type=read'
      else
        redirect_to :back
      end
  end
end
