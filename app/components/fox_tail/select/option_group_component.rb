# frozen_string_literal: true

class FoxTail::Select::OptionGroupComponent < FoxTail::BaseComponent
  attr_reader :label

  renders_many :group_options, lambda { |value, options = {}|
    options[:selected] = Array(selected_value).include?(value) unless options.key? :selected
    FoxTail::Select::OptionComponent.new value, options
  }

  has_option :selected_value

  def initialize(label, html_attributes = {})
    @label = label
    super(html_attributes)
  end

  def before_render
    super

    html_attributes[:label] = label
  end

  def call
    content_tag :optgroup, html_attributes do
      group_options.each { |group_option| concat group_option }
    end
  end
end
