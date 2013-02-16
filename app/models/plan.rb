class Plan
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :price, type: Integer, default: 0
  field :user_limit, type: Integer, default: 0
  field :trial, type: Boolean, default: false

  validates :name, :price, :user_limit, presence: true

  # Accounts
  has_many :accounts

  def self.ordered
    desc(:price)
  end

  def self.paid
    where(:price.gt => 0)
  end

  def self.free
    where(:price => 0)
  end

  def self.trial
    where(trial: true).first
  end

  def self.trial_length
    42
  end

  def free?
    price.zero?
  end

  def billed?
    !free?
  end

  def trial?
    !!trial
  end

  def can_add_more_users?(amount)
    amount <= user_limit
  end

  index({ name: 1 }, { background: true })
end
