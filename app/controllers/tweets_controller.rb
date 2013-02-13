class TweetsController < ApplicationController
  def index
    state = params[:state] ||= 'new'
    case state
      when 'open'   then tweets = Tweet.open_state.limit(10).desc(:created_at)
      when 'closed' then tweets = Tweet.closed_state # requires pagination
      else tweets = Tweet.new_state.limit(10).desc(:created_at)
      end
    @tweets = TweetsDecorator.new(tweets)
  end

  def show
    raise 'Not implemented yet.'
  end

  # PUT /tweets/:id/open
  def open
    @tweet = Tweet.find(params[:id])
    @tweet.open_issue!
    redirect_to :back
  end

  # PUT /tweets/:id/close
  def close
    @tweet = Tweet.find(params[:id])
    @tweet.close!
    redirect_to :back
  end
end
