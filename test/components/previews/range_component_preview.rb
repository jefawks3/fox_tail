# frozen_string_literal: true

# @logical_path forms
# @component Flowbite::RangeComponent
class RangeComponentPreview < ViewComponent::Preview

  # @param disabled toggle
  # @param size select { choices: [sm,base,lg] }
  def playground(disabled: false, size: :base)
    render Flowbite::RangeComponent.new(disabled: disabled, size: size)
  end

  # @!group Disabled

  def active
    render Flowbite::RangeComponent.new(disabled: false)
  end

  def disabled
    render Flowbite::RangeComponent.new(disabled: true)
  end

  # @!endgroup

  # @!group Sizes

  def small
    render Flowbite::RangeComponent.new(size: :sm)
  end

  # @label Base (Default)
  def base
    render Flowbite::RangeComponent.new(size: :base)
  end

  def large
    render Flowbite::RangeComponent.new(size: :lg)
  end

  # @!endgroup
end
