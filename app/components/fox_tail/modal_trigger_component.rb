# frozen_string_literal: true

class FoxTail::ModalTriggerComponent < FoxTail::TriggerBaseComponent
  ACTIONS = {
    click: {show: :click}.freeze,
    toggle: {toggle: :click}.freeze
  }.freeze

  has_option :trigger_type, default: :click

  def modal_controller
    stimulated.with [:fox_tail, :modal]
  end

  def before_render
    super

    ACTIONS[trigger_type]&.each do |method, event|
      trigger_controller.with_action method, on: event
    end
  end
end
