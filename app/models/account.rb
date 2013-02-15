class Account
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships # TODO: Rework

  has_many :projects, dependent: :destroy
  has_many :admins, through: :memberships,
                    source: :user,
                    conditions: { 'memberships.admin' => true }
  has_many :non_admins, through: :memberships,
                    source: :user,
                    conditions: { 'memberships.admin' => false }

  belongs_to :plan, index: true
  belongs_to :coupon, index: true

  delegate :free?, :billed?, :trial?, to: :plan

  field :name, type: String
  field :keyword, type: String
  field :customer_token, type: String
  field :subscription_token, type: String
  field :subscription_status, type: String
  field :next_billing_date, type: Datetime
  field :notified_of_disabling, type: Boolean, default: false
  field :notified_of_expiration, type: Boolean, default: false
  field :notified_of_completed_trial, type: Boolean, default: false
  field :asked_to_activate, type: Boolean, default: false
  field :activated, type: Boolean, default: false
  field :trial_expires_at, type: Datetime

  validates :keyword, uniqueness: true
  validates_format_of :keyword,
    :with    => %r{^[a-z0-9_-]+$},
    :message => "must be only lower case letters and underscores."

  index keyword: 1 , options: { unique: true }
  index next_billing_date: 1
  index created_at: 1
  index trial_expires_at: 1

  before_create :set_trial_expiration
  before_destroy :create_canceled_account

  def to_param
    keyword
  end

  def has_member?(user)
    memberships.exists?(user_id: user.id)
  end

  def users_by_name
    users.by_name
  end

  def projects_by_name
    projects.by_name
  end

  def projects_visible_to(user)
    projects.visible_to(user)
  end

  def memberships_by_name
    memberships.by_name
  end

  def expired?
    trial? && past_trial?
  end

  def past_trial?
    trial_expires_at && trial_expires_at < Time.current
  end

  def admin_emails
    admins.map(&:email)
  end

  def set_trial_expiration
    self.trial_expires_at = 30.days.from_now
  end

  def users_count
    users.count
  end

  def projects_count
    projects.active.count
  end

  private

  def create_canceled_account
    CanceledAccount.create(account: self)
  end
end
