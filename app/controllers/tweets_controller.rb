class TweetsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_company

  def index
    @tweets = @company.tweets.order('created_at DESC').limit(100)
  end

  def destroy
    tweet = @company.tweets.find(params[:id])
    tweet.destroy
    render json: {}
  end

protected

  def find_company
    @company = current_user.company
  end
end
