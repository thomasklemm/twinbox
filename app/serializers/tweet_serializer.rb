class TweetSerializer < ActiveModel::Serializer
  attributes :id,
    :text,
    :user_name,
    :user_screen_name
end
