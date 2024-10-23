# frozen_string_literal: true

# @logical_path components
# @component FoxTail::ProgressBarComponent
class ProgressBarComponentPreview < ViewComponent::Preview
  # @param progress range { min: 0, max: 100, step: 1 }
  # @param color select { choices: [default,blue,red,yellow,green,indigo,purple,pink] }
  # @param size select { choices: [xs,sm,base,lg,xl] }
  # @param show_label toggle
  # @param label
  # @param controlled toggle
  def playground(progress: 45, color: :default, size: :base, show_label: false, label: nil, controlled: false)
    component = FoxTail::ProgressBarComponent.new progress.to_i,
      color: color,
      size: size,
      show_label: show_label,
      controlled: controlled

    component.with_content label if label.present?

    render component
  end

  # @!group Sizes

  def extra_small
    render FoxTail::ProgressBarComponent.new(45, size: :xs)
  end

  def small
    render FoxTail::ProgressBarComponent.new(45, size: :sm)
  end

  # @label Base (Default)
  def base
    render FoxTail::ProgressBarComponent.new(45, size: :base)
  end

  def large
    render FoxTail::ProgressBarComponent.new(45, size: :lg)
  end

  def extra_large
    render FoxTail::ProgressBarComponent.new(45, size: :xl)
  end

  # @!endgroup

  # @!group Color

  def default
    render FoxTail::ProgressBarComponent.new(45, color: :default)
  end

  def blue
    render FoxTail::ProgressBarComponent.new(45, color: :blue)
  end

  def red
    render FoxTail::ProgressBarComponent.new(45, color: :red)
  end

  def yellow
    render FoxTail::ProgressBarComponent.new(45, color: :yellow)
  end

  def green
    render FoxTail::ProgressBarComponent.new(45, color: :green)
  end

  def purple
    render FoxTail::ProgressBarComponent.new(45, color: :purple)
  end

  def indigo
    render FoxTail::ProgressBarComponent.new(45, color: :indigo)
  end

  def pink
    render FoxTail::ProgressBarComponent.new(45, color: :pink)
  end
  # @!endgroup

  # @!group Controlled
  def uncontrolled
    render FoxTail::ProgressBarComponent.new(45, size: :lg, controlled: false, show_label: true)
  end

  def controlled
    render FoxTail::ProgressBarComponent.new(45, size: :lg, controlled: true, show_label: true)
  end
  # @!endgroup
end
