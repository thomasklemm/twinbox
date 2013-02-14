class Limit
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :plan, index: true

  field :name, type: String
  field :value, type: Integer, default: 0
  field :value_type, type: String, default: 'number'

  validates :name, :value, :value_type, presence: true

  def self.numbered
    where(value_type: :number)
  end

  def self.boolean
    where(value_type: :boolean)
  end

  def self.named(name)
    where(name: name).first
  end

  def self.within?(limit_name, account)
    if account.plan.limit(limit_name)
      account.plan.limit(limit_name).within?(account)
    else
      true
    end
  end

  def self.can_add_one?(limit_name, account)
    if account.plan.limit(limit_name)
      account.plan.limit(limit_name).can_add_one?(account)
    else
      true
    end
  end

  def allowed?
    value != 0
  end

  def within?(account)
    current_count(account) <= value
  end

  def can_add_one?(account)
    (current_count(account) + 1) <= value
  end

  def current_count(account)
    account.send(:"#{name}_count")
  end
end
