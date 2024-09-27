# frozen_string_literal: true

class FoxTail::RadioButtonComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Formable
  include FoxTail::Concerns::HasStimulusController

  has_option :color, default: :default
  has_option :size, default: :base
  has_option :value
  has_option :checked, as: :boolean, default: false
  has_option :controlled, type: :boolean, default: false

  def value
    options[:value] ||= value_from_object
  end

  def checked?
    return !!options[:checked] if options.key? :checked
    return false unless object.present?

    value.to_s == value_from_object.to_s
  end

  def use_stimulus?
    super && controlled?
  end

  def stimulus_controller_options
    {}
  end

  def before_render
    super

    add_default_name_and_id_for_value value
    html_attributes[:type] = :radio
    html_attributes[:class] = classnames theme.apply(:root, self), html_class
    html_attributes[:value] = value
    html_attributes[:checked] = checked?
  end

  def call
    tag :input, html_attributes
  end

  class << self
    def stimulus_controller_name
      "form-field"
    end
  end

  class StimulusController < FoxTail::StimulusController; end
end
