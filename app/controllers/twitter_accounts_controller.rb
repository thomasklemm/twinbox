class TwitterAccountsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_company
  before_filter :find_twitter_account, only: [:track_mentions, :untrack_mentions]

  def index
    @twitter_accounts = @company.twitter_accounts
  end

  def track_mentions
    @twitter_account.track_mentions!
    flash.notice = "Tracking mentions for Twitter account @#{@twitter_account.login}"
    redirect_to twitter_accounts_path
  end

  def untrack_mentions
    @twitter_account.untrack_mentions!
    flash.notice = "No longer tracking mentions for Twitter account @#{@twitter_account.login}"
    redirect_to twitter_accounts_path
  end

protected

  def find_company
    @company = current_user.company
  end

  def find_twitter_account
    @twitter_account = @company.twitter_accounts.find(params[:id])
  end
end
