# frozen_string_literal: true

class FoxTail::PasswordInputTriggerComponent < FoxTail::TriggerBaseComponent
  def before_render
    super

    html_attributes[:class] = classnames theme.apply("root/hidden", self), html_class
    html_attributes[:aria] ||= {}
    html_attributes[:aria][:controls] = selector.gsub(/^[#|.]/, "")
    html_attributes[:aria][:expanded] = false

    trigger_controller.with_class :hidden, theme.apply("root/hidden", self)
    trigger_controller.with_class :visible, theme.apply("root/visible", self)
    trigger_controller.with_action :toggle
  end
end
