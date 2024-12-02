# frozen_string_literal: true

class FoxTail::DismissibleTriggerComponent < FoxTail::TriggerBaseComponent
  def trigger_type
    options[:trigger_type] ||= :click
  end

  def before_render
    super

    with_action :dismiss if trigger_type == :click
  end
end
