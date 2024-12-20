# frozen_string_literal: true

class FoxTail::InputBaseComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Formable
  include FoxTail::Concerns::Placeholderable
  include FoxTail::Concerns::ControllableFormField

  has_option :size, default: :base
  has_option :state
  has_option :required, type: :boolean, default: false

  def before_render
    super

    add_default_name_and_id
    update_state_from_object!
    html_attributes[:placeholder] = retrieve_placeholder if placeholder?
    html_attributes[:required] = required?
  end

  protected

  def can_read_only?
    true
  end

  def can_disable?
    true
  end

  def update_state_from_object!
    return unless object? && !options.key(:state)

    options[:state] = if object_errors?
      :invalid
    else
      :none
    end
  end
end
