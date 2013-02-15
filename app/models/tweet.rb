class Tweet
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
  include Workflow

  # Fields
  field :twitter_id,            type: Integer
  field :text,                  type: String
  field :created_at,            type: DateTime
  field :in_reply_to_status_id, type: Integer
  field :in_reply_to_user_id,   type: Integer

  # Embeds one author
  embeds_one :author, autobuild: true

  # Embeds many events
  embeds_many :events

  # Validations
  # TODO: Scope to account
  validates :twitter_id, uniqueness: true

  # Scopes
  scope :new_state,    where(workflow_state: :new)
  scope :open_state,   where(workflow_state: :open)
  scope :closed_state, where(workflow_state: :closed)

  # Workflow
  # fields stores workflow state
  field :workflow_state, type: String
  workflow_column :workflow_state

  # Define workflow with states, events and transitions
  workflow do
    # Define states, events and transitions
    # A tweets starts in the :new state
    # Make states idempotent
    state :new do
      # For some reason :open as the event name
      # raises some open_uri errors
      event :open_issue, transitions_to: :open # main change
      event :close, transitions_to: :closed    # main change
    end
    state :open do
      event :close, transitions_to: :closed    # main change
      event :open_issue, transitions_to: :open # idempotent state change
    end
    # Tweets end in :closed state
    state :closed do
      event :open_issue, transitions_to: :open # main, though less expected change
      event :close, transitions_to: :closed    # idempotent state change
    end

    # Define transition hooks
    # Create an embedded event for each transition
    on_transition do |from_state, to_state, triggering_event, *event_args|
      events.create! do |e|
        e.from_state = from_state
        e.event_name = triggering_event
        e.to_state = to_state
      end
    end
  end

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

