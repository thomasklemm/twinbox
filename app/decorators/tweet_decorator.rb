class TweetDecorator < Draper::Decorator
  delegate_all
  include Twitter::Autolink

  # Autolink text
  def text
    auto_link(model.text).html_safe
  end

  ##
  # Links
  def open_tweet_link(text)
    h.link_to text, h.open_tweet_path(model), method: :put
  end

  def close_tweet_link(text)
    h.link_to text, h.close_tweet_path(model), method: :put
  end

  def reply_intent_link(text)
    h.link_to text, "https://twitter.com/intent/tweet?in_reply_to=#{ model.twitter_id }"
  end

  def retweet_intent_link(text)
    h.link_to text, "https://twitter.com/intent/retweet?tweet_id=#{ model.twitter_id }"
  end

  # Embedded author
  decorates_association :author

  # Embedded events
  decorates_association :events
end
