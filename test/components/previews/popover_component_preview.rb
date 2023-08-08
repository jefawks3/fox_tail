# frozen_string_literal: true

# @component Flowbite::PopoverComponent
# @logical_path components
class PopoverComponentPreview < ViewComponent::Preview

  # @param placement select { choices: [top,left,bottom,right] } "Where to place the popover"
  # @param arrow toggle "Show the arrow"
  # @param header toggle "Show the popover title"
  # @param trigger_type select { choices: [hover,click] } "How to trigger the popover"
  # @param delay number "The delay used when the trigger type is 'hover'"
  def playground(placement: :top, arrow: true, header: true, trigger_type: :hover, delay: 300)
    render_with_template locals: {
      placement: placement,
      arrow: arrow,
      header: header,
      trigger_type: trigger_type,
      delay: delay,
    }
  end

  # @!group Position

  def right
    render(Flowbite::PopoverComponent.new(:right_popover, placement: :right)) do |c|
      c.with_trigger(class: "ml-80 text-gray-900 dark:text-white underline cursor-pointer") { "Hover over me" }
      c.with_header { "Popover title" }
      "And here's some amazing content. It's very engaging. Right?"
    end
  end

  def bottom
    render(Flowbite::PopoverComponent.new(:bottom_popover, placement: :bottom)) do |c|
      c.with_trigger(class: "ml-80 text-gray-900 dark:text-white underline cursor-pointer") { "Hover over me" }
      c.with_header { "Popover title" }
      "And here's some amazing content. It's very engaging. Right?"
    end
  end

  def left
    render(Flowbite::PopoverComponent.new(:left_popover, placement: :left)) do |c|
      c.with_trigger(class: "ml-80 text-gray-900 dark:text-white underline cursor-pointer") { "Hover over me" }
      c.with_header { "Popover title" }
      "And here's some amazing content. It's very engaging. Right?"
    end
  end

  # @label Top (Default)
  def top
    render(Flowbite::PopoverComponent.new(:top_popover, placement: :top)) do |c|
      c.with_trigger(class: "ml-80 text-gray-900 dark:text-white underline cursor-pointer") { "Hover over me" }
      c.with_header { "Popover title" }
      "And here's some amazing content. It's very engaging. Right?"
    end
  end

  # @!endgroup


  # @!group Trigger Type

  def trigger_with_click
    render(Flowbite::PopoverComponent.new(:click_popover, trigger_type: :click)) do |c|
      c.with_trigger(tag: :button, class: "ml-80 text-gray-900 dark:text-white underline cursor-pointer") { "Click me" }
      c.with_header { "Popover title" }
      "And here's some amazing content. It's very engaging. Right?"
    end
  end

  def trigger_with_hover
    render(Flowbite::PopoverComponent.new(:hover_popover, trigger_type: :hover)) do |c|
      c.with_trigger(class: "ml-80 text-gray-900 dark:text-white underline cursor-pointer") { "Hover over me" }
      c.with_header { "Popover title" }
      "And here's some amazing content. It's very engaging. Right?"
    end
  end

  # @!endgroup
end
