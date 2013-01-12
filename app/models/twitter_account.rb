# == Schema Information
#
# Table name: twitter_accounts
#
#  company_id   :integer
#  created_at   :datetime         not null
#  id           :integer          not null, primary key
#  login        :text
#  token        :text
#  token_secret :text
#  uid          :text
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_twitter_accounts_on_company_id  (company_id)
#

class TwitterAccount < ActiveRecord::Base
  belongs_to :company
  has_many :queries, dependent: :destroy

  def track_mentions?
    queries.any?
  end

  def track_mentions!
    queries.where(query_type: :mentions).first_or_create!
  end

  def untrack_mentions!
    queries.where(query_type: :mentions).find_each(&:destroy)
  end

  attr_accessible :uid, :login, :token, :token_secret
end
