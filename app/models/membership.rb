class Membership
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :account
  has_many :permissions, dependent: :destroy
  def projects
    permissions.flat_map(&:projects) # has_many :projects, through: :permissions
  end

  field :admin, type: Boolean, default: false

  validates :user, :account, :admin, presence: true
  validates_uniqueness_of :user_id, scope: :account_id

  index({account_id: 1, user_id: 1}, {unique: true})

  def self.admin
    where(admin: true)
  end

  def name
    user.name
  end

  def email
    user.email
  end

  def self.by_name
    raise 'Not implemented'
  end
end
