# frozen_string_literal: true

class FoxTail::PasswordInputComponent < FoxTail::InputComponent
  has_option :control_visibility, type: :boolean, default: false

  stimulated_with [:fox_tail, :password_input], as: :password_visibility, if: :control_visibility?

  def before_render
    super

    html_attributes[:type] = :password
    html_attributes[:spellcheck] = false unless html_attributes.key? :spellcheck
  end
end
