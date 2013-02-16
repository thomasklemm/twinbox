class Account
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  validates :name, presence: true

  # Members can work on project of account
  has_many :members, class_name: 'User', inverse_of: :account

  def has_member?(user)
    members.include?(user)
  end

  # Owner can update billing for account
  belongs_to :owner, class_name: 'User', inverse_of: :owned_account, index: true

  # Plan (chosen plan)
  belongs_to :plan, index: true
  validates :plan, presence: true

  # Assign the trial plan on creation
  after_initialize :assign_trial_plan
  def assign_trial_plan
    self.plan = Plan.trial
  end

  delegate :free?, :billed?, :trial?, to: :plan

  field :trial_expires_at, type: Time
  after_initialize :set_trial_expiration
  def set_trial_expiration
    self.trial_expires_at = Plan.trial_length.days.from_now(created_at || Time.current)
  end

  def expired?
    trial? && past_trial?
  end

  def past_trial?
    trial_expires_at && trial_expires_at < Time.current
  end

  # Project
  has_one :project, autobuild: true
  validates :project, presence: true
end
