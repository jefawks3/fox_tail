# frozen_string_literal: true

class FoxTail::PopoverTriggerComponent < FoxTail::TriggerBaseComponent
  ACTIONS = {
    hover: {
      hoverShow: :hover_in,
      hoverHide: :hover_out
    }.freeze,
    click: {
      toggle: :click,
      hide: %i[focusout blur].freeze
    }.freeze
  }.freeze

  has_option :delay, default: 300
  has_option :trigger_type, default: :hover

  def before_render
    super

    trigger_controller.with_value :delay, delay

    ACTIONS[trigger_type]&.each do |method, event|
      trigger_controller.with_action method, on: event
    end
  end

  def stimulus_controller_options
    super.merge delay: delay
  end
end
