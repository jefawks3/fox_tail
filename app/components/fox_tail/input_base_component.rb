# frozen_string_literal: true

class FoxTail::InputBaseComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Formable
  include FoxTail::Concerns::Placeholderable

  has_option :size, default: :base
  has_option :state

  def initialize(*)
    super

    update_state_from_object!
  end

  def before_render
    super

    add_default_name_and_id
    html_attributes[:placeholder] = retrieve_placeholder if placeholder?
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
                      elsif html_attributes[:value].present?
                        :valid
                      else
                        :none
                      end
  end
end
