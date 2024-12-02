# frozen_string_literal: true

class FoxTail::AutocompleteComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Formable
  include FoxTail::Concerns::Placeholderable
  include FoxTail::Concerns::ControllableFormField

  renders_one :hidden_input, lambda { |attributes = {}|
    add_default_name_and_id attributes: attributes
    attributes[:value] = value
    attributes[:type] = :hidden
    attributes[:name] = name
    attributes[:data] ||= {}
    attributes[:data][autocomplete_controller.target_attribute_name] = :value

    tag.input(**attributes)
  }

  renders_one :input, lambda { |options = {}, &block|
    options = objectify_options options
    options.merge! fox_tail_input_options
    options[:class] = classnames theme.apply(:input, self), options[:class], html_class
    options[:autocomplete] ||= "off"
    options[:spellcheck] = false unless options.key?(:spellcheck)
    options[:id] = input_id
    options[:name] = "#{name}_text" if name?
    options[:value] = text
    options[:type] = :search
    options[:placeholder] = retrieve_placeholder if placeholder?
    options[:data] ||= {}
    options[:data][autocomplete_controller.target_attribute_name] = :input

    FoxTail::DropdownTriggerComponent.new nil do |trigger|
      component = FoxTail::InputComponent.new trigger.html_attributes.merge(options)

      component.with_right_spinner(
        class: theme.apply(:loader, self),
        data: {autocomplete_controller.target_attribute_name => :loader}
      )

      render component, &block
    end
  }

  renders_one :dropdown, lambda { |options = {}|
    options[:class] = classnames theme.apply(:dropdown, self), options[:class]
    options[:trigger_id] = input_id
    options[:offset] ||= 0
    options[:disable_click_outside] = true
    options[:data] ||= {}
    options[:data][autocomplete_controller.target_attribute_name] = :dropdown

    FoxTail::DropdownComponent.new options
  }

  has_option :name
  has_option :id, as: :input_id
  has_option :param, default: :q
  has_option :value
  has_option :text
  has_option :error_message

  include_options_from FoxTail::InputComponent

  stimulated_with [:fox_tail, :autocomplete], as: :autocomplete do |controller|
    controller.with_value :url, @url
    controller.with_value :param, param
  end

  def initialize(url, html_attributes = {})
    super(html_attributes)

    @url = url
  end

  def value
    options.key?(:value) ? options[:value].presence : value_from_object
  end

  def text
    options.key?(:text) ? options[:text].presence : value
  end

  def input_id
    options[:input_id] ||=
      "#{self.class.name.underscore.gsub("_component", "").gsub("/", "_")}_#{SecureRandom.base58(6)}"
  end

  def before_render
    super

    with_input unless input?
    with_hidden_input unless hidden_input?
    with_dropdown unless dropdown?

    html_attributes[:class] = theme.apply(:root, self)
  end

  def call
    content_tag :div, html_attributes do
      concat hidden_input
      concat input
      concat dropdown
    end
  end

  def render_search_results(options = {}, &block)
    raise ArgumentError, "block not given" unless block

    render FoxTail::DropdownComponent.new(options).with_menu, &block
  end

  def render_search_results_in(view_context, options = {}, &block)
    set_original_view_context view_context
    render_search_results options, &block
  end
end
