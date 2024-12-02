# frozen_string_literal: true

class FoxTail::ListenerControllerComponent < FoxTail::WrapperComponent
  has_option :query
  has_option :events

  stimulated_with [:fox_tail, :listener], as: :listener do |controller|
    controller.with_value :query, query
    controller.with_value :events, events
  end
end
