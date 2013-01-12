# == Schema Information
#
# Table name: queries
#
#  company_id         :integer
#  created_at         :datetime         not null
#  id                 :integer          not null, primary key
#  last_performed_at  :datetime
#  last_scheduled_at  :datetime
#  max_tweet_id       :integer
#  term               :text
#  twitter_account_id :integer
#  type               :text
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_queries_on_company_id          (company_id)
#  index_queries_on_twitter_account_id  (twitter_account_id)
#

class Query < ActiveRecord::Base
  belongs_to :company
  belongs_to :twitter_account
  attr_accessible :version, :term, :last_performed_at, :last_scheduled_at, :max_tweet_id
end
