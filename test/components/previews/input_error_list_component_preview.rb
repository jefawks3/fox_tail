# frozen_string_literal: true

# @logical_path forms
# @component Flowbite::InputErrorListComponent
class InputErrorListComponentPreview < ViewComponent::Preview
  def default
    render Flowbite::InputErrorListComponent.new do |c|
      c.with_message "cannot be blank"
      c.with_message do
        "must include something"
      end
    end
  end

  def record_errors
    model = User.new
    model.errors.add :name, "cannot be blank"
    render Flowbite::InputErrorListComponent.new(object_name: :user, object: model, method_name: :name)
  end
end
