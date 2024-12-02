# frozen_string_literal: true

class FoxTail::DropdownTriggerComponent < FoxTail::TriggerBaseComponent
  ACTIONS = {
    hover: {
      show: :click,
      hoverShow: :mouseenter,
      hoverHide: :mouseleave
    }.freeze,
    click: {
      toggle: :click
    }.freeze,
  }.freeze

  ACTION_ALIASES = {toggle: :click}.freeze

  has_option :delay, default: 300
  has_option :open, default: false, type: :boolean
  has_option :trigger_type, default: :click

  def before_render
    super

    html_attributes[:class] = classnames(
      theme.apply(:root, self),
      theme.apply("root/#{open? ? :open : :close}", self),
      html_class
    )

    trigger_controller.with_value :delay, delay
    trigger_controller.with_class :open, theme.apply("root/open", self)
    trigger_controller.with_class :closed, theme.apply("root/closed", self)

    ACTIONS[trigger_type]&.each do |method, event|
      trigger_controller.with_action method, on: event
    end
  end
end
