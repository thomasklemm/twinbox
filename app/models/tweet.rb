# == Schema Information
#
# Table name: tweets
#
#  company_id       :integer
#  created_at       :datetime         not null
#  id               :integer          not null, primary key
#  text             :text
#  tweet_id         :integer
#  updated_at       :datetime         not null
#  user_name        :text
#  user_screen_name :text
#
# Indexes
#
#  index_tweets_on_company_id  (company_id)
#

class Tweet < ActiveRecord::Base
  belongs_to :company
  attr_accessible :text, :tweet_id, :user_name, :user_screen_name
end
