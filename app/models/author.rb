class Author
  include Mongoid::Document

  # Fields
  field :twitter_id,  type: Integer
  field :name,        type: String
  field :screen_name, type: String
  field :location,    type: String
  field :description, type: String
  field :url,         type: String
  field :verified,    type: Boolean,   default: false
  field :created_at,  type: DateTime
  field :followers_count,   type: Integer, default: 0
  field :friends_count,     type: Integer, default: 0
  field :profile_image_url, type: String
  field :profile_image_url_https, type: String

  # Tweet
  embedded_in :tweet
end