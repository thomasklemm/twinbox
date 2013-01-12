class TwitterAccountsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @twitter_accounts = current_user.company.twitter_accounts
  end
end
