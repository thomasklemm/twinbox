module ApplicationHelper
  # Autolinking with Twitter text gem
  # auto_link('my_text')
  include Twitter::Autolink

  # Hide certain content when response is set to be cached
  # in public caches (such as e.g. Rack Cache)
  def publicly_cached?
    !!(response.cache_control[:public])
  end

  # Set a DNS Prefetch tag
  def dns_prefetch(url)
    "<link rel='dns-prefetch' href='#{ url }'>".html_safe
  end

  # Mark navigation entries as active when state matches
  def active_state(state)
    "active" if params[:state] == state.to_s
  end

  def current_new_tweet_count
    current_count(Tweet.new_state.count)
  end

  def current_open_tweet_count
    current_count(Tweet.open_state.count)
  end

private

  def current_count(count)
    content_tag(:span, count, class: 'current-tweet-count')
  end
end
