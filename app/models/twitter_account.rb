class TwitterAccount
  include Mongoid::Document
  include Mongoid::Timestamps

  # Project
  belongs_to :project, index: true
  validates :project, presence: true

  # Credentials
  field :uid,          type: String
  field :token,        type: String
  field :token_secret, type: String

  validates :uid, :token, :token_secret, presence: true

  # Details
  field :twitter_id,  type: Integer
  field :name,        type: String
  field :screen_name, type: String
  field :location,    type: String
  field :description, type: String
  field :url,         type: String
  field :profile_image_url_https, type: String

  validates :screen_name, presence: true

  # Permissions
  field :read_permissions,     type: Boolean, default: true
  field :write_permissions,    type: Boolean, default: false
  field :messages_permissions, type: Boolean, default: false

  # Create or update existing Twitter account
  def self.from_omniauth(auth, project, auth_scope)
    t = project.twitter_accounts.where(uid: auth.uid).first_or_initialize # uid cannot change

    # Credentials
    t.token        = auth.credentials.token   # can change, e.g. by changing access level...
    t.token_secret = auth.credentials.secret  #  ...or by revoking and reauthorizing access

    # User info
    user = auth.extra.raw_info
    t.twitter_id  = user.id
    t.name        = user.name
    t.screen_name = user.screen_name
    t.location    = user.location
    t.description = user.description
    t.url         = user.url
    t.profile_image_url_https = user.profile_image_url_https

    # Set twitter authentcation scope for the provided credentials
    t.map_auth_scope(auth_scope)

    # Save and return twitter account
    t.save! && t
  end

  # Set correct authentication scopes of Twitter account
  def map_auth_scope(auth_scope)
    case auth_scope
      when :read
        self.read_permissions     = true
        self.write_permissions    = false
        self.messages_permissions = false
      when :write
        self.read_permissions     = true
        self.write_permissions    = true
        self.messages_permissions = false
      when :messages
        self.read_permissions     = true
        self.write_permissions    = true
        self.messages_permissions = true
      else
        raise "No twitter auth scope given, was #{ auth_scope.to_s }"
      end
  end

  def to_param
    screen_name
  end
end
