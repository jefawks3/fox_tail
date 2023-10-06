# frozen_string_literal: true

class FoxTail::Stepper::StepComponent < FoxTail::BaseComponent
  DEFAULT_COMPLETED_ICON = "check"
  DEFAULT_VERTICAL_CURRENT_ICON = "arrow-right"

  renders_one :visual, types: {
    icon: {
      as: :icon,
      renders: lambda { |icon, options = {}|
        options[:class] = classnames theme.apply(:icon, self), options[:class]
        FoxTail::IconBaseComponent.new icon, options
      }
    },
    svg: {
      as: :svg,
      renders: lambda { |path, options = {}|

      }
    },
    image: {
      as: :image,
      renders: lambda { |source, options = {}|

      }
    }
  }

  has_option :variant, default: :default
  has_option :state, default: :pending
  has_option :index, default: 0

  def before_render
    super

    initialize_visual
    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  private

  def initialize_visual
    return if visual?

    if state == :completed && (content? || variant == :vertical)
      with_icon DEFAULT_COMPLETED_ICON
    elsif state == :current && variant == :vertical
      with_icon DEFAULT_VERTICAL_CURRENT_ICON
    end
  end
end
