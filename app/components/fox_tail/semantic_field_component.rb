# frozen_string_literal: true

class FoxTail::SemanticFieldComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Formable

  renders_one :label, ->(text_or_options = {}, options = {}) {
    if text_or_options.is_a?(Hash)
      options = text_or_options
      text_or_options = nil
    end

    options = options.merge(extract_options_for(FoxTail::LabelComponent))
    options[:id] ||= "#{id}_label" if id.present?
    options[:class] = classnames theme.apply(:label, self), options[:class]

    component = FoxTail::LabelComponent.new(options)
    component.with_content text_or_options if text_or_options.present?
    component
  }

  renders_one :action, types: {
    show_password_button: {
      as: :show_password_action,
      renders: ->(options = {}) {
        options = options.merge(extract_options_for(FoxTail::ShowPasswordComponent))
        options[:class] = theme.apply("header/action", self, options)

        FoxTail::ShowPasswordComponent.new(options)
      }
    },
    button: {
      as: :button_action,
      renders: ->(text_or_options = {}, options = {}) {
        if text_or_options.is_a?(Hash)
          options = text_or_options
          text_or_options = nil
        end

        options[:class] = theme.apply("header/action", self), options[:class]

        component = FoxTail::ButtonComponent.new(options)
        component.with_content text_or_options if text_or_options.present?
        component
      }
    },
    link: {
      as: :link_action,
      renders: ->(text_or_options = {}, options = {}) {
        if text_or_options.is_a?(Hash)
          options = text_or_options
          text_or_options = nil
        end

        options[:class] = theme.apply("header/action", self), options[:class]

        component = FoxTail::LinkComponent.new(options)
        component.with_content text_or_options if text_or_options.present?
        component
      }
    },
    action: {
      as: :action,
      renders: ->(options = {}) {
        options[:class] = theme.apply("header/action", self), options[:class]

        FoxTail::WrapperComponent.new options
      }
    }
  }

  renders_one :input, types: {
    input: {
      as: :input_field,
      renders: ->(options = {}) { create_input_component FoxTail::InputComponent, options }
    },
    text: {
      as: :text_field,
      renders: ->(options = {}) { create_input_component FoxTail::InputComponent, options.merge(type: :text) }
    },
    password: {
      as: :password_field,
      renders: ->(options = {}) { create_input_component FoxTail::PasswordInputComponent, options }
    },
    color: {
      as: :color_field,
      renders: ->(options = {}) { create_input_component FoxTail::InputComponent, options.merge(type: :color) }
    },
    search: {
      as: :search_field,
      renders: ->(options = {}) { create_input_component FoxTail::InputComponent, options.merge(type: :search) }
    },
    telephone: {
      as: :telephone_field,
      renders: ->(options = {}) { create_input_component FoxTail::InputComponent, options.merge(type: :tel) }
    },
    phone: {
      as: :phone_field,
      renders: ->(options = {}) { create_input_component FoxTail::InputComponent, options.merge(type: :tel) }
    },
    date: {
      as: :date_field,
      renders: ->(options = {}) { create_input_component FoxTail::InputComponent, options.merge(type: :date) }
    },
    datetime: {
      as: :datetime_field,
      renders: ->(options = {}) { create_input_component FoxTail::InputComponent, options.merge(type: :"datetime-local") }
    },
    datetime_local: {
      as: :datetime_local_field,
      renders: ->(options = {}) { create_input_component FoxTail::InputComponent, options.merge(type: :"datetime-local") }
    },
    time: {
      as: :time_field,
      renders: ->(options = {}) { create_input_component FoxTail::InputComponent, options.merge(type: :time) }
    },
    month: {
      as: :month_field,
      renders: ->(options = {}) { create_input_component FoxTail::InputComponent, options.merge(type: :month) }
    },
    week: {
      as: :week_field,
      renders: ->(options = {}) { create_input_component FoxTail::InputComponent, options.merge(type: :week) }
    },
    email: {
      as: :email_field,
      renders: ->(options = {}) { create_input_component FoxTail::InputComponent, options.merge(type: :email) }
    },
    number: {
      as: :number_field,
      renders: ->(options = {}) { create_input_component FoxTail::InputComponent, options.merge(type: :number) }
    },
    autocomplete: {
      as: :autocomplete_field,
      renders: ->(options = {}) { create_input_component FoxTail::AutocompleteComponent, options }
    },
    range: {
      as: :range_field,
      renders: ->(options = {}) { create_input_component FoxTail::RangeComponent, options }
    },
    text_area: {
      as: :text_area,
      renders: ->(options = {}) { create_input_component FoxTail::TextareaComponent, options }
    },
    file: {
      as: :file_field,
      renders: ->(options = {}) { create_input_component FoxTail::FileInputComponent, options }
    },
    dropzone: {
      as: :dropzone_field,
      renders: ->(options = {}) { create_input_component FoxTail::DropzoneComponent, options }
    },
    check_box: {
      as: :check_box,
      renders: ->(options = {}) { create_input_component FoxTail::CheckboxComponent, options }
    },
    toggle: {
      as: :toggle_switch,
      renders: ->(options = {}) { create_input_component FoxTail::ToggleComponent, options }
    },
    radio_button: {
      as: :radio_button,
      renders: ->(options = {}) { create_input_component FoxTail::RadioButtonComponent, options }
    },
    select: {
      as: :select,
      renders: ->(options = {}) { create_input_component FoxTail::SelectComponent, options }
    },
    input_group: {
      as: :input_group,
      renders: ->(options = {}) { create_input_component FoxTail::InputGroupComponent, options }
    },
    wrapped: {
      as: :field,
      renders: ->(options = {}) {
        options[:class] = classnames theme.apply(:input, self), options[:class]
        FoxTail::WrapperComponent.new options
      }
    }
  }

  renders_one :help_text, ->(text_or_options = {}, options = {}) {
    if text_or_options.is_a?(Hash)
      options = text_or_options
      text_or_options = nil
    end

    options = options.merge(extract_options_for(FoxTail::HelperTextComponent))
    options[:class] = classnames theme.apply(:help_text, self), options[:class]

    component = FoxTail::HelperTextComponent.new(options)
    component.with_content text_or_options if text_or_options.present?
    component
  }

  renders_one :link, ->(url, text_or_options = {}, options = {}) {
    if text_or_options.is_a?(Hash)
      options = text_or_options
      text_or_options = nil
    end

    options[:class] = classnames theme.apply("footer/link", self), options[:class]

    component = FoxTail::LinkComponent.new(url, options)
    component.with_content text_or_options if text_or_options.present?
    component
  }

  renders_one :error_list, ->(options = {}) {
    options = options.merge(extract_options_for(FoxTail::InputErrorListComponent))
    options[:class] = classnames theme.apply(:error_list, self), options[:class]

    FoxTail::InputErrorListComponent.new(options)
  }

  has_option :id
  has_option :as, as: :input_type, default: :input
  has_option :variant, default: :default
  has_option :required, type: :boolean, default: false
  has_option :state

  include_options_from FoxTail::LabelComponent
  include_options_from FoxTail::InputErrorListComponent
  include_options_from FoxTail::HelperTextComponent

  include_options_from FoxTail::ShowPasswordComponent

  include_options_from FoxTail::InputComponent
  include_options_from FoxTail::PasswordInputComponent
  include_options_from FoxTail::AutocompleteComponent
  include_options_from FoxTail::TextareaComponent
  include_options_from FoxTail::FileInputComponent
  include_options_from FoxTail::DropzoneComponent
  include_options_from FoxTail::CheckboxComponent
  include_options_from FoxTail::ToggleComponent
  include_options_from FoxTail::RadioButtonComponent
  include_options_from FoxTail::SelectComponent
  include_options_from FoxTail::InputGroupComponent

  def before_render
    super

    with_label unless label?
    with_show_password_action if !action? && control_visibility?
    with_help_text unless help_text?
    with_error_list unless error_list?
    with_input unless input?
  end

  def with_input(*, &)
    if respond_to?("with_#{input_type}_field")
      send("with_#{input_type}_field", *, &)
    else
      send("with_#{input_type}", *, &)
    end
  end

  def extract_options_for(klass)
    options.slice(*klass.registered_options.keys)
  end

  private

  def create_input_component(klass, options)
    options = options.merge(extract_options_for(klass))
    options[:id] = id if id.present?
    options[:class] = classnames theme.apply(:input, self), options[:class]
    klass.new options
  end
end
