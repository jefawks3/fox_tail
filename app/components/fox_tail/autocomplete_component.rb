# frozen_string_literal: true

class FoxTail::AutocompleteComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Formable
  include FoxTail::Concerns::Placeholderable
  include FoxTail::Concerns::HasStimulusController

  renders_one :hidden_input, lambda { |attributes = {}|
    add_default_name_and_id attributes: attributes
    attributes[:value] = value
    attributes[:type] = :hidden
    attributes[:name] = name

    if use_stimulus?
      attributes[:data] ||= {}
      attributes[:data][stimulus_controller.target_key] = :value
    end

    tag.input(attributes)
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

    if use_stimulus?
      options[:data] ||= {}
      options[:data][stimulus_controller.target_key] = :input
    end

    FoxTail::DropdownTriggerComponent.new nil do |trigger|
      component = FoxTail::InputComponent.new stimulus_merger.merge_attributes(trigger.html_attributes, options)

      if use_stimulus?
        component.with_right_spinner :class => theme.apply(:loader, self),
          stimulus_controller.target_key(raw: true) => :loader
      end

      render component, &block
    end
  }

  renders_one :dropdown, lambda { |options = {}|
    options[:class] = classnames theme.apply(:dropdown, self), options[:class]
    options[:trigger_id] = input_id
    options[:offset] ||= 0
    options[:disable_click_outside] = true

    if use_stimulus?
      options[:data] ||= {}
      options[:data][stimulus_controller.target_key] = :dropdown
    end

    FoxTail::DropdownComponent.new options
  }

  has_option :name
  has_option :id, as: :input_id
  has_option :param, default: :q
  has_option :value
  has_option :text
  has_option :error_message

  include_options_from FoxTail::InputComponent

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

  def stimulus_controller_options
    {
      url: @url,
      param: param
    }
  end

  def render_search_results(options = {}, &block)
    raise ArgumentError, "block not given" unless block

    render FoxTail::DropdownComponent.new(options).with_menu, &block
  end

  def render_search_results_in(view_context, options = {}, &block)
    set_original_view_context view_context
    render_search_results options, &block
  end

  class << self
    def append_option_action(value, text = nil, attributes = {})
      actions = stimulus_merger.merge_actions attributes.dig(:data, :action), stimulus_controller.action(:select)
      attributes[:data] ||= {}
      attributes[:data][:action] = actions
      attributes[:data][stimulus_controller.action_param_key(:value)] = value
      attributes[:data][stimulus_controller.action_param_key(:text)] = text
      attributes
    end
  end

  class StimulusController < FoxTail::StimulusController
    def attributes(options = {})
      attributes = super
      attributes[:data][value_key(:url)] = options[:url]
      attributes[:data][value_key(:param)] = options[:param]
      attributes
    end
  end
end
