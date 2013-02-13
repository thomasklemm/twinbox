class EventDecorator < Draper::Decorator
  delegate_all

  def message
    "Marked as #{ to_state } at #{ created_at.to_s(:short) }"
  end
end
