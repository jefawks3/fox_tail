# frozen_string_literal: true

class FoxTail::FilterBarComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Identifiable

  renders_many :hidden_fields, lambda { |name, value = nil, options = {}|
    hidden_field_tag name, value, options
  }

  renders_many :static_filters, types: {
    keyword: {
      as: :static_keyword_filter,
      renders: lambda { |name, options = {}| keyword_filter_component name, options }
    },
    autocomplete: {
      as: :static_autocomplete_filter,
      renders: lambda { |name, url, options = {}| autocomplete_filter_component name, url, options }
    },
    select_input: {
      as: :static_select_filter,
      renders: lambda { |name, options = {}| select_filter_component name, options }
    },
    dropdown: {
      as: :static_dropdown_filter,
      renders: lambda { |label, options = {}| dropdown_filter_component label, options }
    }
  }

  renders_many :filters, types: {
    keyword: {
      as: :keyword_filter,
      renders: lambda { |name, options = {}| keyword_filter_component name, options }
    },
    autocomplete: {
      as: :autocomplete_filter,
      renders: lambda { |name, url, options = {}| autocomplete_filter_component name, url, options }
    },
    select_input: {
      as: :select_filter,
      renders: lambda { |name, options = {}| select_filter_component name, options }
    },
    dropdown: {
      as: :dropdown_filter,
      renders: lambda { |label, options = {}| dropdown_filter_component label, options }
    }
  }

  renders_one :filter_toggle, types: {
    icon_button: {
      as: :filter_icon_button_trigger,
      renders: lambda { |options = {}, &block|
        icon = options.delete(:icon) { :funnel }

        render_filter_button_toggle :icon_button, options, block do |attributes|
          FoxTail::IconButtonComponent.new icon, attributes
        end
      }
    },
    button: {
      as: :filter_button_trigger,
      renders: lambda { |options = {}, &block|
        render_filter_button_toggle :button, options, block do |attributes|
          FoxTail::ButtonComponent.new attributes
        end
      }
    },
    trigger: {
      as: :filter_trigger,
      renders: lambda { |options = {}|
        type = options.delete(:type) || :custom
        options[:class] = filter_toggle_classnames type, options
        filter_trigger_component options
      }
    }
  }

  renders_many :submit_buttons, types: {
    button: {
      as: :submit_button,
      renders: lambda { |options = {}|
        options[:type] = :submit
        options[:size] = size
        options[:class] = submit_classnames :button, options
        FoxTail::ButtonComponent.new options
      }
    },
    icon_button: {
      as: :submit_icon_button,
      renders: lambda { |options = {}|
        icon = options.delete(:icon) { :magnifying_glass }
        options[:type] = :submit
        options[:size] = size
        options[:class] = submit_classnames :icon_button, options
        FoxTail::IconButtonComponent.new icon, options
      }
    }
  }

  has_option :url
  has_option :turbo, type: :boolean, default: false
  has_option :size, default: :sm
  has_option :params

  def initialize(html_attributes = {})
    super(html_attributes)
  end

  def url
    options[:url] ||= request.path
  end

  def params
    options[:params] ||= view_context.try(:params)
  end

  def before_render
    super

    with_submit_button.with_content(t('.submit')) unless submit_buttons?
    with_filter_icon_button_trigger unless filter_toggle?

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
    html_attributes[:method] ||= :get
  end

  def keyword_filter_component(name, options = {})
    add_default_filter_options name, :keyword, options
    icon = options.delete(:icon) { :magnifying_glass }
    component = FoxTail::InputComponent.new options
    component.with_left_icon icon if icon.present?
    component
  end

  def autocomplete_filter_component(name, url, options = {})
    add_default_filter_options name, :autocomplete, options
    FoxTail::AutocompleteComponent.new url, options
  end

  def select_filter_component(name, options = {})
    add_default_filter_options name, :select, options
    FoxTail::SelectComponent.new options
  end

  def dropdown_filter_component(label, options = {})
    icon = options.delete(:icon) { :chevron_down }
    dropdown_classes = options.delete(:dropdown_class)
    button_options = options.extract!(:size, :color, :class).reverse_merge(color: :neutral)
    button_options[:class] = filter_classnames :dropdown, options
    button_options[:size] = size

    component = FoxTail::DropdownComponent.new options.merge(class: dropdown_classes)

    component.with_trigger(button_options) do |trigger|
      render(FoxTail::ButtonComponent.new(trigger.html_attributes)) do |button|
        button.with_right_icon icon
        content_tag :span, label, class: theme.apply("dropdown_filter.button", self)
      end
    end

    component
  end

  def filter_trigger_component(options = {})
    FoxTail::CollapsibleTriggerComponent.new "##{collapsible_id}", options
  end

  def collapsible_id
    "#{id}_collapsible"
  end

  private

  def filter_classnames(type, options)
    classnames theme.apply(:filter, self), theme.apply("#{type}_filter", self), options[:class]
  end

  def filter_toggle_classnames(type, options)
    classnames theme.apply(:filter, self),
               theme.apply("#{type}_filter", self),
               theme.apply(:filter_toggle, self),
               theme.apply("filter_toggle_#{type}", self),
               options[:class]
  end

  def submit_classnames(type, options)
    classnames theme.apply(:filter, self),
               theme.apply("#{type}_filter", self),
               theme.apply(:submit, self),
               theme.apply("submit_#{type}", self),
               options[:class]
  end

  def add_default_filter_options(name, type, options)
    options[:name] = options[:multiple] ? "#{name}[]" : name
    options[:value] ||= params[name]
    options[:class] = filter_classnames type, options
    options[:size] = size
    options
  end

  def render_filter_button_toggle(type, options, block)
    indicator = options.delete :indicator
    text = options.delete(:text) { t('.filter_toggle') }
    options[:size] = size
    options[:color] ||= :light
    options[:class] = filter_toggle_classnames type, options

    render filter_trigger_component(options) do |trigger|
      render yield(trigger.html_attributes) do |button|
        if indicator.is_a? TrueClass
          button.with_dot_indicator
        elsif indicator.present?
          button.with_badge_indicator_content indicator
        end

        if block
          capture(button, &block).presence || text
        else
          text
        end
      end
    end
  end
end
