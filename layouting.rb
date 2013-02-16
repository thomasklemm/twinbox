class Account
  include Mongoid::Document
  include Mongoid::Timestamps

  field :admin_ids, type: Array # store the admin ids e.g. with an observer

  has_and_belongs_to_many :users

  def has_member?(user)
    users.include?(user)
  end

  has_one :project
end

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  has_and_belongs_to_many :accounts

  def admin_of?(account)
    account.admin_ids.include?(self.id)
  end

  def member_of?(account_or_project)
    account_or_project.has_member?(self)
  end
end

class Plan
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :price, type: Integer, default: 0
  field :user_limit, type: Integer, default: 0

  validates :name, :price, :user_limit, presence: true

  index name: 1, { background: true }

  def self.ordered
    desc(:price)
  end

  def self.paid
    where(:price.gt => 0)
  end

  def self.free
    where(:price => 0)
  end

  def free?
    price.zero?
  end

  def billed?
    !free?
  end

  def can_add_more_users?(amount)
    amount <= user_limit
  end
end

class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :account, index: true

  # has many queries, mentions_queries, search_queries, results, tweets, replies, canned_replies ...
end

