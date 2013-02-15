class Account
  include Mongoid::Document
  include Mongoid::Timestamps

  # Users
  # can work on project of account
  has_many :users, dependent: :destroy

  # Admins
  # can invite users to account
  field :admin_ids, type: Array
  def admins
    users.where(id: :admin_ids)
  end

  # Owner
  # can update billing for account
  belongs_to :owner

  # Project
  has_one :project,
    autobuild: true











  # belongs_to :plan, index: true
  # belongs_to :coupon, index: true

  # delegate :free?, :billed?, :trial?, to: :plan

  # field :name, type: String
  # field :keyword, type: String
  # field :customer_token, type: String
  # field :subscription_token, type: String
  # field :subscription_status, type: String
  # field :next_billing_date, type: Time
  # field :notified_of_disabling, type: Boolean, default: false
  # field :notified_of_expiration, type: Boolean, default: false
  # field :notified_of_completed_trial, type: Boolean, default: false
  # field :asked_to_activate, type: Boolean, default: false
  # field :activated, type: Boolean, default: false
  # field :trial_expires_at, type: Time

  # validates :keyword, uniqueness: true
  # validates_format_of :keyword,
  #   :with    => %r{^[a-z0-9_-]+$},
  #   :message => "must be only lower case letters and underscores."

  # index keyword: 1 , options: { unique: true }
  # index next_billing_date: 1
  # index created_at: 1
  # index trial_expires_at: 1

  # before_create :set_trial_expiration

  # def has_member?(user)
  #   memberships.exists?(user_id: user.id)
  # end

  # def users_by_name
  #   users.by_name
  # end

  # def projects_by_name
  #   projects.by_name
  # end

  # def projects_visible_to(user)
  #   projects.visible_to(user)
  # end

  # def memberships_by_name
  #   memberships.by_name
  # end

  # def expired?
  #   trial? && past_trial?
  # end

  # def past_trial?
  #   trial_expires_at && trial_expires_at < Time.current
  # end

  # def admin_emails
  #   admins.map(&:email)
  # end

  # private

  # def create_canceled_account
  #   CanceledAccount.create(account: self)
  # end
end
