# frozen_string_literal: true

class FoxTail::TooltipTriggerComponent < FoxTail::TriggerBaseComponent
  ACTIONS = {
    hover: {
      show: :hover_in,
      hide: :hover_out
    }.freeze,
    click: {
      toggle: :click,
      hide: %i[focusout blur].freeze
    }.freeze
  }.freeze

  has_option :trigger_type, default: :hover

  def before_render
    super

    ACTIONS[trigger_type]&.each do |method, event|
      trigger_controller.with_action method, on: event
    end
  end
end
