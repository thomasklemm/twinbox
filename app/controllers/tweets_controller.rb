class TweetsController < ApplicationController
  def index
    @tweets = Tweet.limit(50).desc(:created_at).decorate
  end
end
