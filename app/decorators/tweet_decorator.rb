class TweetDecorator < Draper::Decorator
  include Twitter::Autolink

  def text
    auto_link(model.text).html_safe
  end

  # Author
  def author_profile_image
    h.image_tag(author.profile_image_url, size: '48x48')
  end

  def author_name
    author.name
  end

  def author_screen_name
    h.link_to "@#{ author.screen_name }", "https://twitter.com/#{ author.screen_name }"
  end


  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       source.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
