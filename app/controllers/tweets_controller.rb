class TweetsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_company
  before_filter :find_tweets

  def index
    @tweets = @tweets.order('created_at DESC')
    render json: @tweets
  end

  def show
    @tweet = @tweets.find(params[:id])
    render json: @tweet
  end

  def create # should be done another way
    @tweet = @tweets.new(params[:tweet])
    if @tweet.save
      render json: @tweet, status: :created, location: @tweet
    else
      render json: @tweet.errors, status: :unprocessable_entity
    end
  end

  def update
    @tweet = @tweets.find(params[:id])
    if @tweet.update_attributes(params[:tweet])
      render json: nil, status: :ok
    else
      render json: @tweet.errors, status: :unprocessable_entity
    end
  end

  def destroy
    tweet = @tweets.find(params[:id])
    tweet.destroy
    render json: nil, status: :ok
  end

protected

  def find_company
    @company = current_user.company
  end

  def find_tweets
    @tweets = @company.tweets
  end
end
