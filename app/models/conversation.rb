class Conversation
  include Mongoid::Document
  include Mongoid::Timestamps

  # Project
  belongs_to :project, index: true

  # Tweets
  has_many :tweets
end
