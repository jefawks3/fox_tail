# frozen_string_literal: true

class FoxTail::DrawerTriggerComponent < FoxTail::TriggerBaseComponent
  has_option :open, default: false, type: :boolean
  has_option :action, default: :toggle
  has_option :trigger_type

  def before_render
    super

    html_attributes[:class] = classnames(
      theme.apply(:root, self),
      theme.apply("root/#{open? ? :open : :close}", self),
      html_class
    )

    trigger_controller.with_class :open, theme.apply("root/open", self)
    trigger_controller.with_class :closed, theme.apply("root/closed", self)
    trigger_controller.with_action action, on: trigger_type if action?
  end
end
