# frozen_string_literal: true

class FormBuilderPreview < Lookbook::Preview

  def default
    instance = User.new
    instance.assign_attributes email: "test@example.com"
    instance.errors.add :email, "already taken"
    render_with_template locals: { model: instance }
  end
end
