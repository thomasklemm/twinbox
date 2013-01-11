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

  # Create or update a Twitter account
  # from omniauth
  def create_or_update_twitter_account(auth)
    account = twitter_accounts.where(
      uid: auth.uid,
      read_token:   twitter_application_token(auth, :read_token),
      write_token:  twitter_application_token(auth, :write_token)
    ).first

    if account
      account.update_attributes(map_attrs(auth))
    else
      twitter_accounts.create!(map_attrs(auth))
    end
  end

  # Review: Should this be placed somewhere else or protected?
  # Determine which Twitter Application has been used in authorization process
  def twitter_application_token(auth, scope)
    consumer_key = auth.extra.access_token.consumer.key
    case scope
      when :read_token
        !!(consumer_key == ENV['TWITTER_READ_CONSUMER_KEY'])
      when :write_token
        !!(consumer_key == ENV['TWITTER_WRITE_CONSUMER_KEY'])
      else
        raise 'This twitter application scope is unknown'
      end
  end

  def map_attrs(auth)
    { uid:   auth.uid,
    login: auth.info.nickname,
    token: auth.credentials.token,
    token_secret: auth.credentials.secret,
    read_token:   twitter_application_token(auth, :read_token),
    write_token:  twitter_application_token(auth, :write_token) }
  end

  attr_accessible :name
end
