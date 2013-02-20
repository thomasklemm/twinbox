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

  # Belongs to project
  belongs_to :project, index: true
  validates :project, presence: true

  # Validations
  validates_uniqueness_of :twitter_id, scope: :project

  # Belongs to conversation
  belongs_to :conversation, index: true

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

    # History state, with no action required
    state :history

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
  def self.from_twitter(project, statuses, options={})
    statuses &&= [statuses].flatten.reverse
    source = options.fetch(:source) # raises KeyError if not present

    statuses.each do |status|
      tweet = project.tweets.find_or_create_by(twitter_id: status.id) do |t|
        t.assign_tweet_fields(status)
        t.assign_tweet_author_fields(status)
        t.assign_workflow_state(source)
      end

      tweet.set_conversation(source)
    end
  end

  def assign_tweet_fields(status)
    self.twitter_id            = status.id
    self.text                  = status.text
    self.created_at            = status.created_at
    self.in_reply_to_status_id = status.in_reply_to_status_id
    self.in_reply_to_user_id   = status.in_reply_to_user_id
  end

  def assign_tweet_author_fields(status)
    self.author.twitter_id  = status.user.id
    self.author.name        = status.user.name
    self.author.screen_name = status.user.screen_name
    self.author.location    = status.user.location
    self.author.description = status.user.description
    self.author.url         = status.user.url
    self.author.verified    = status.user.verified
    self.author.created_at  = status.user.created_at
    self.author.followers_count   = status.user.followers_count
    self.author.friends_count     = status.user.friends_count
    self.author.profile_image_url = status.user.profile_image_url_https
  end

  def assign_workflow_state(source)
    case source
      when :mentions_timeline
        # Initial state 'new'
      when :user_timeline
        self.workflow_state = 'history'
      when :build_conversation_history
        self.workflow_state = 'history'
      end
  end

  def set_conversation(source)
    # No conversation should be created
    return if source == :build_conversation_history

    # Create and set conversations only when replies come in
    return unless in_reply_to_status_id.present?

    # Find or retrieve and create the previous tweet from Twitter
    previous_tweet = find_or_create_previous_tweet(in_reply_to_status_id)

    # Find or create and associate conversation
    if previous_tweet.has_conversation?
      self.conversation = previous_tweet.conversation
      self.save!
    else
      c = project.conversations.create!
      c.tweets << previous_tweet
      c.tweets << self # includes persisting of tweet
    end
  end

  def find_or_create_previous_tweet(twitter_id)
    previous_tweet = project.tweets.find_by(twitter_id: twitter_id)
  rescue
    twitter_client = project.twitter_client
    response = twitter_client.status(twitter_id)
    Tweet.from_twitter(project, response, source: :build_conversation_history)
    previous_tweet = project.tweets.find_by(twitter_id: twitter_id)
  ensure
    previous_tweet
  end

  def to_param
    twitter_id
  end
end

