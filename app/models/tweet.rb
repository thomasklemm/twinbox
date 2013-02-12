class Tweet
  include Mongoid::Document
  include Workflow

  # Fields
  field :twitter_id,            type: Integer
  field :text,                  type: String
  field :created_at,            type: DateTime
  field :in_reply_to_status_id, type: Integer
  field :in_reply_to_user_id,   type: Integer
  field :workflow_status,       type: String # for Workflow

  # Author
  embeds_one :author, autobuild: true

  # Validations
  # TODO: Scope to account
  validates :twitter_id, uniqueness: true

  # Workflow
  workflow_column :workflow_status
  workflow do
    state :new do
      event :needs_response, transitions_to: :awaiting_response
      event :appreciate, transitions_to: :appreciated
    end
    state :appreciated do
      event :needs_response, transitions_to: :awaiting_response
    end
    state :awaiting_response do
      event :solve, transitions_to: :solved
    end
    state :solved
  end
  # TODO: Define event creation on state changes by naming methods like events

  # Create one or many tweets from twitter statuses
  def self.from_twitter(*statuses)
    statuses &&= statuses.flatten.reverse
    # TODO: Scope to account
    statuses.each do |status|
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
  end

end

