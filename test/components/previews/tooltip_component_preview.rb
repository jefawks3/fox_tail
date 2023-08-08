# frozen_string_literal: true

# @component Flowbite::TooltipComponent
# @logical_path components
class TooltipComponentPreview < ViewComponent::Preview

  # @param placement select { choices: [top,bottom,right,left] } "Which side to place the tooltip"
  # @param arrow toggle "Show the arrow"
  # @param variant select { choices: [dark,light] } "The tooltip theme style"
  def playground(placement: :top, arrow: true, variant: :dark)
    render_with_template locals: { placement: placement, arrow: arrow, variant: variant }
  end

  # @!group Position

  # @label Top (Default)
  def top
    render(Flowbite::TooltipComponent.new(:top_tooltip, placement: :top)) do |c|
      c.with_trigger(class: "ml-40 text-gray-900 dark:text-white underline cursor-pointer") do
        "Hover over me"
      end
      "Tooltip Content"
    end
  end

  def bottom
    render(Flowbite::TooltipComponent.new(:bottom_tooltip, placement: :bottom)) do |c|
      c.with_trigger(class: "ml-40 text-gray-900 dark:text-white underline cursor-pointer") do
        "Hover over me"
      end
      "Tooltip Content"
    end
  end

  def left
    render(Flowbite::TooltipComponent.new(:left_tooltip, placement: :left)) do |c|
      c.with_trigger(class: "ml-40 text-gray-900 dark:text-white underline cursor-pointer") do
        "Hover over me"
      end
      "Tooltip Content"
    end
  end

  def right
    render(Flowbite::TooltipComponent.new(:right_tooltip, placement: :right)) do |c|
      c.with_trigger(class: "ml-40 text-gray-900 dark:text-white underline cursor-pointer") do
        "Hover over me"
      end
      "Tooltip Content"
    end
  end

  # @!endgroup

  # @!group Styles

  # @label Dark (Default)
  def dark
    render(Flowbite::TooltipComponent.new(:dark_tooltip, variant: :dark)) do |c|
      c.with_trigger(class: "ml-40 text-gray-900 dark:text-white underline cursor-pointer") do
        "Hover over me"
      end
      "Tooltip Content"
    end
  end

  def light
    render(Flowbite::TooltipComponent.new(:light_tooltip, variant: :light)) do |c|
      c.with_trigger(class: "ml-40 text-gray-900 dark:text-white underline cursor-pointer") do
        "Hover over me"
      end
      "Tooltip Content"
    end
  end

  # @label Disabled Arrow
  def no_arrow
    render(Flowbite::TooltipComponent.new(:no_arrow_tooltip, arrow: false)) do |c|
      c.with_trigger(class: "ml-40 text-gray-900 dark:text-white underline cursor-pointer") do
        "Hover over me"
      end
      "Tooltip Content"
    end
  end

  # @!endgroup

  # @!group Inline

  def without_inline
    render_with_template template: 'tooltip_component_preview/inline', locals: { tooltip_id: :without_inline, inline: false }
  end


  def inline
    render_with_template template: 'tooltip_component_preview/inline', locals: { tooltip_id: :inline, inline: true }
  end

  # @!endgroup
end
