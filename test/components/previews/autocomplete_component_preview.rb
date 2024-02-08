# frozen_string_literal: true

# @component FoxTail::AutocompleteComponent
# @logical_path forms
class AutocompleteComponentPreview < ViewComponent::Preview
  def playground
    render(FoxTail::AutocompleteComponent.new("/clients", placeholder: "Search clients"))
  end
end
