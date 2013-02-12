class Tweet
  include Mongoid::Document

  # Fields
  field :twitter_id,            type: Integer
  field :text,                  type: String
  field :created_at,            type: DateTime
  field :in_reply_to_status_id, type: Integer
  field :in_reply_to_user_id,   type: Integer

  # Author
  embeds_one :author, autobuild: true

  # Validations
  # TODO: Scope to account
  validates :twitter_id, uniqueness: true

  # Create a tweet from twitter status
  def self.from_twitter(status)
    # TODO: Scope to account
    find_or_create_by(twitter_id: status.id) do |t|
      # Tweet fields
      t.twitter_id            = status.id
      t.text                  = status.text
      t.created_at            = status.created_at
      t.in_reply_to_status_id = status.in_reply_to_status_id
      t.in_reply_to_user_id   = status.in_reply_to_user_id

      # Author fields
      t.author.twitter_id  = status.user.id
      t.author.name        = status.user.name
      t.author.screen_name = status.user.screen_name
      t.author.location    = status.user.location
      t.author.description = status.user.description
      t.author.url         = status.user.url
      t.author.verified    = status.user.verified
      t.author.created_at  = status.user.created_at
      t.author.followers_count   = status.user.followers_count
      t.author.friends_count     = status.user.friends_count
      t.author.profile_image_url = status.user.profile_image_url
      t.author.profile_image_url_https = status.user.profile_image_url_https
    end
  end

  # Create many tweets from twitter statues
  def self.many_from_twitter(statuses)
    statuses.reverse.each { |status| from_twitter(status) }
  end

end

