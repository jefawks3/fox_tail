# frozen_string_literal: true

class FoxTail::PasswordInputComponent < FoxTail::InputComponent
  include FoxTail::Concerns::HasStimulusController

  has_option :controlled, type: :boolean, default: false

  def use_stimulus?
    super && controlled?
  end

  def stimulus_controller_options
    {}
  end

  def before_render
    super

    html_attributes[:type] = :password
    html_attributes[:spellcheck] = false unless html_attributes.key? :spellcheck
  end

  class StimulusController < FoxTail::StimulusController; end
end
