# frozen_string_literal: true

module FoxTail::Concerns::Choosable
  extend ActiveSupport::Concern

  included do
    has_option :choices
  end

  protected

  def add_choices
    return unless choices?

    choices.each do |choice|
      text, value, options = extract_choice_values choice

      if value.is_a? Array
        add_choice_group text, value
      else
        add_choice value, text, options
      end
    end
  end

  def add_choice(value, label, options = {})
    raise NotImplementedError
  end

  def add_choice_group(label, choices)
    raise NotImplementedError
  end

  def extract_choice_values(choice)
    if choice.is_a? Array
      choice[1] ||= choice[0]
      choice[2] ||= {}
      choice
    else
      [choice, choice, {}]
    end
  end
end
