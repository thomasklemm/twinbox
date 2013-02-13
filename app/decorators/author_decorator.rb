class AuthorDecorator < Draper::Decorator
  delegate_all

  # Author's profile image
  def profile_image
    h.image_tag(model.profile_image_url, size: '48x48')
  end

  # Screen name enhanced with user web intent
  def screen_name
    h.link_to "@#{ model.screen_name }", "https://twitter.com/intent/user?screen_name=#{ model.screen_name }"
  end
end
