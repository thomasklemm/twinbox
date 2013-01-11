# == Schema Information
#
# Table name: companies
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  name       :text             not null
#  updated_at :datetime         not null
#

class Company < ActiveRecord::Base
  # Validations
  validates :name, presence: true

  # Employees
  has_many :users

  # Twitter Accounts
  has_many :twitter_accounts

  # Create or update a Twitter account from omniauth
  def create_or_update_twitter_account(auth)
    account = twitter_accounts.find_by_uid(auth.uid)
    account.present? ? update_twitter_account(account, auth) : create_twitter_account(auth)
  end

  def update_twitter_account(account, auth)
    account.update_attributes({
      uid:   auth.uid,               # cannot change
      login: auth.info.nickname,     # can change
      token: auth.credentials.token, # can change, e.g. by changing access level...
      token_secret: auth.credentials.secret # ...or by revoking and reauthorizing access
    })
  end

  def create_twitter_account(auth)
    twitter_accounts.create!({
      uid:   auth.uid,
      login: auth.info.nickname,
      token: auth.credentials.token,
      token_secret: auth.credentials.secret
    })
  end

  attr_accessible :name
end
