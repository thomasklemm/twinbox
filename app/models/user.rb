class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields and validations
  field :name, type: String
  validates :name, presence: true

  # Include default devise modules. Others available are:
  # :token_authenticatable, :omniauthable and :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable

  # Database authenticatable
  # Devise seems to validate the presence of the email and password fields itself
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""
  validates :email, uniqueness: true

  # Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  # Rememberable
  field :remember_created_at, :type => Time

  # Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  # Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String # Only if using reconfirmable

  # Lockable
  field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String

  # Owned account, the one that the user created and oversees
  has_one :owned_account, class_name: 'Account', inverse_of: :owner
  accepts_nested_attributes_for :owned_account
  # validates_associated :owned_account
  validates :owned_account, presence: true

  # Build owned account unless there is already an account or owned account associated
  after_initialize :build_intermediate_owned_account
  def build_intermediate_owned_account
    self.build_owned_account unless has_owned_account? || has_account?
  end

  # Account that the user is associated with
  belongs_to :account, class_name: 'Account', inverse_of: :members

  # Extravagant after_create callback that would otherwise
  # trigger sending two confirmation emails
  # See http://stackoverflow.com/questions/13061775/devise-actionmailer-sending-duplicate-emails-for-registration-confirmation
  def generate_confirmation_token
    make_owner_an_account_member
    super
  end

  # Make the user a member of his owned account
  def make_owner_an_account_member
    self.account = owned_account if has_owned_account?
  end

  # Indexes
  index({ email: 1 }, { unique: true, background: true })

  # Attribute whitelisting
  attr_accessible :name, :email, :password, :remember_me, :owned_account_attributes
end
