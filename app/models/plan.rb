class Plan
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :accounts
  has_many :limits

  field :name, type: String
  field :price, type: Integer, default: 0
  field :trial, type: Boolean, default: false

  validates :name, :price, presence: true

  index({ name: 1 } , { background: true })

  # Class
  scope :ordered, desc(:price)

  def self.paid_by_price
    paid.ordered
  end

  def self.trial
    free.first
  end

  scope :paid, where(:price.gt => 0)
  scope :free, where(price: 0)

  # Instance
  def free?
    price.zero?
  end

  def billed?
    !free?
  end

  def can_add_more?(limit, amount)
    limits.numbered.named(limit).value > amount
  end

  def allows?(limit)
    limits.boolean.named(limit).allowed?
  end

  def limit(limit_name)
    limits.named(limit_name)
  end
end
