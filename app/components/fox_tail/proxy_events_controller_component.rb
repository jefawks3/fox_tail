# frozen_string_literal: true

class FoxTail::ProxyEventsControllerComponent < FoxTail::WrapperComponent
  has_option :selector

  stimulated_with [:fox_tail, :proxy_events], as: :proxy_events do |controller|
    controller.with_value :query, selector
  end
end
