# frozen_string_literal: true

class FoxTail::SelectComponent < FoxTail::InputBaseComponent
  include FoxTail::Concerns::Placeholderable
  include FoxTail::Concerns::Choosable

  has_option :disabled, type: :boolean, default: false
  has_option :value
  has_option :include_hidden, type: :boolean, default: true
  has_option :include_blank, type: :boolean, default: false

  renders_one :prompt, lambda { |text, selected: false, disabled: true|
    FoxTail::Select::OptionComponent.new("", disabled: disabled, selected: selected).with_content(text)
  }

  renders_many :select_options, types: {
    option: {
      as: :select_option,
      renders: lambda { |value, options = {}|
        options[:selected] = Array(self.value).include?(value) unless options.key? :selected
        FoxTail::Select::OptionComponent.new value, options
      }
    },
    group: {
      as: :select_group,
      renders: lambda { |label, options = {}|
        options[:selected_value] = self.value
        FoxTail::Select::OptionGroupComponent.new label, options
      }
    }
  }

  def value
    options[:value] ||= value_before_type_cast
  end

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
    html_attributes[:multiple] = :multiple if html_attributes[:multiple]

    if placeholder?
      with_prompt retrieve_placeholder, selected: value_from_object.nil?
    elsif include_blank?
      with_prompt "", disabled: false, selected: value_from_object.nil?
    end

    add_choices
  end

  def call
    capture do
      concat render_hidden if html_attributes[:multiple].present? && include_hidden?
      concat render_select
    end
  end

  protected

  def can_read_only?
    false
  end

  def can_disable?
    true
  end

  def add_choice(value, label, options = {})
    with_select_option(value, options).with_content(label)
  end

  def add_choice_group(label, choices)
    with_select_group label do |group|
      choices.each do |choice|
        text, value, options = extract_choice_values choice
        group.with_group_option(value, options).with_content(text)
      end
    end
  end

  private

  def render_hidden
    tag :input, disabled: disabled?, name: html_attributes[:name], type: :hidden, value: "", autocomplete: :off
  end

  def render_select
    content_tag :select, html_attributes do
      concat prompt if prompt?
      select_options.each { |select_option| concat select_option } if select_options?
      concat content if content?
    end
  end
end
