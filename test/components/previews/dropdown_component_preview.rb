# frozen_string_literal: true

# @component Flowbite::DropdownComponent
# @logical_path components
class DropdownComponentPreview < ViewComponent::Preview

  # @param placement select { choices: [top,bottom,left,right,top-start,top-end,bottom-start,bottom-end,right-start,right-end,left-start,left-end] } "Where to place the dropdown"
  # @param offset number "Distance from the trigger"
  # @param shift number "Offset relative to the placement"
  # @param trigger_type select { choices: [click,hover] }
  # @param delay number "Delay to show/hide when trigger type is 'hover'"
  def playground(placement: "bottom", shift: 0, offset: 10, delay: 300, trigger_type: :click)
    render_with_template locals: {
      placement: placement,
      shift: shift,
      offset: offset,
      delay: delay,
      trigger_type: trigger_type
    }
  end

  # @!group Styles

  def default
    render(Flowbite::DropdownComponent.new(:dropdown_default, placement: "bottom-start")) do |c|
      c.with_button_trigger.with_content "Dropdown Button"
      c.with_menu do |menu|
        menu.with_item.with_content "Dashboard"
        menu.with_item.with_content "Settings"
        menu.with_item.with_content "Earnings"
        menu.with_item.with_content "Sign Out"
      end
    end
  end

  def with_dividers
    render(Flowbite::DropdownComponent.new(:dropdown_with_dividers, placement: "bottom-start")) do |c|
      c.with_button_trigger.with_content "Dropdown Button"
      c.with_menu do |menu|
        menu.with_item.with_content "Dashboard"
        menu.with_item.with_content "Settings"
        menu.with_item.with_content "Earnings"
      end
      c.with_menu do |menu|
        menu.with_item.with_content "Sign Out"
      end
    end
  end

  def with_header
    render(Flowbite::DropdownComponent.new(:dropdown_with_header, placement: "bottom-start")) do |c|
      c.with_button_trigger.with_content "Dropdown Button"
      c.with_header do
        # Normally would use `concat` to join tag helpers; `concat` is not available in the ViewComponent preview
        content_tag(:div, "User Name") +
          content_tag(:div, "name@flowbite-viewcomponents.com", class: "font-medium truncate")
      end
      c.with_menu do |menu|
        menu.with_item.with_content "Dashboard"
        menu.with_item.with_content "Settings"
        menu.with_item.with_content "Earnings"
      end
      c.with_menu do |menu|
        menu.with_item.with_content "Sign Out"
      end
    end
  end

  def with_custom_content
    render_with_template template: "dropdown_component_preview/with_custom_content"
  end

  # @!endgroup

  # @!group Trigger Types

  def button_trigger
    render(Flowbite::DropdownComponent.new(:dropdown_button_trigger, placement: "bottom-start")) do |c|
      c.with_button_trigger.with_content "Dropdown Button"
      c.with_menu do |menu|
        menu.with_item.with_content "Dashboard"
        menu.with_item.with_content "Settings"
        menu.with_item.with_content "Earnings"
        menu.with_item.with_content "Sign Out"
      end
    end
  end

  def icon_button_trigger
    render(Flowbite::DropdownComponent.new(:dropdown_icon_button_trigger, placement: "bottom-start")) do |c|
      c.with_icon_button_trigger "ellipsis-vertical", variant: :outline
      c.with_menu do |menu|
        menu.with_item.with_content "Dashboard"
        menu.with_item.with_content "Settings"
        menu.with_item.with_content "Earnings"
        menu.with_item.with_content "Sign Out"
      end
    end
  end

  # @label Custom Trigger (Avatar)
  def avatar_trigger
    render_with_template template: "dropdown_component_preview/avatar_trigger"
  end

  # @!endgroup

  # @!group Trigger Events

  def on_click
    render(Flowbite::DropdownComponent.new(:dropdown_click)) do |c|
      c.with_button_trigger.with_content "Dropdown Button"
      c.with_menu do |menu|
        menu.with_item.with_content "Dashboard"
        menu.with_item.with_content "Settings"
        menu.with_item.with_content "Earnings"
        menu.with_item.with_content "Sign Out"
      end
    end
  end

  def on_hover
    render(Flowbite::DropdownComponent.new(:dropdown_hover, trigger_type: :hover)) do |c|
      c.with_button_trigger.with_content "Dropdown Button"
      c.with_menu do |menu|
        menu.with_item.with_content "Dashboard"
        menu.with_item.with_content "Settings"
        menu.with_item.with_content "Earnings"
        menu.with_item.with_content "Sign Out"
      end
    end
  end

  # @!endgroup
end
