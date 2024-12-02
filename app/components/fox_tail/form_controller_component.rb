# frozen_string_literal: true

class FoxTail::FormControllerComponent < FoxTail::WrapperComponent
  has_option :enabled, type: :boolean, default: true

  stimulated_with [:fox_tail, :form], as: :form do |controller|
    controller.with_value :enabled, enabled?
  end
end
