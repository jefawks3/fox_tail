# frozen_string_literal: true

class ButtonGroupComponentPreview < ViewComponent::Preview

  def default
    render(Flowbite::ButtonGroupComponent.new) do |c|
      c.with_button.with_content("One")
      c.with_button.with_content("Two")
      c.with_button.with_content("Three")
    end
  end
end
