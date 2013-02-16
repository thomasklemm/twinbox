class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  # Account
  belongs_to :account, index: true
  validates :account, presence: true

  delegate :name, to: :account

  # Twitter accounts
  has_many :twitter_accounts

end
