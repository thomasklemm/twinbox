class Event
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  # Embedded in tweet
  embedded_in :tweet

  # Fields
  field :from_state, type: String
  field :event_name, type: String
  field :to_state,   type: String

  # Validations
  validates :event_name, :from_state, :to_state, presence: true
end
