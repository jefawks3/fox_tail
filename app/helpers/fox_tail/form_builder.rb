# frozen_string_literal: true

class FoxTail::FormBuilder < ActionView::Helpers::FormBuilder
  def controlled? = false

  def body(options = {}, &block)
    @template.render FoxTail::FormBodyComponent.new(options), &block
  end

  def actions(options = {}, &block)
    options[:form_controlled] = controlled? unless options.key?(:form_controlled)

    @template.render FoxTail::FormActionsComponent.new(options), &block
  end

  def label(method, text = nil, options = {}, &block)
    if text.is_a? Hash
      options = text
      text = nil
    end

    options = objectify_component_options method, options
    component = FoxTail::LabelComponent.new options
    component.with_content text if !block && text.present?
    @template.render component, &block
  end

  def show_password_button(method, options = {}, &block)
    options = objectify_component_options method, options
    component = FoxTail::ShowPasswordComponent.new options
    @template.render component, &block
  end

  def help_text(method, text = nil, options = {}, &block)
    if text.is_a?(Hash)
      options = text
      text = nil
    end

    options = objectify_component_options method, options
    component = FoxTail::HelperTextComponent.new options
    component.with_content text if text.present?
    @template.render component, &block
  end

  def error_list(method, options = {}, &block)
    options = objectify_component_options method, options
    @template.render FoxTail::InputErrorListComponent.new(options), &block
  end

  def text_field(method, options = {}, &block)
    input_field method, options.merge(type: :text), &block
  end

  def semantic_text_field(method, options = {}, &block)
    semantic_field method, options.merge(as: :text_field), &block
  end

  def password_field(method, options = {}, &block)
    options = objectify_component_options method, options
    @template.render FoxTail::PasswordInputComponent.new(options), &block
  end

  def semantic_password_field(method, options = {}, &block)
    semantic_field method, options.merge(as: :password_field), &block
  end

  def color_field(method, options = {}, &block)
    input_field method, options.merge(type: :color), &block
  end

  def semantic_color_field(method, options = {}, &block)
    semantic_field method, options.merge(as: :color_field), &block
  end

  def search_field(method, options = {}, &block)
    input_field method, options.merge(type: :search), &block
  end

  def semantic_search_field(method, options = {}, &block)
    semantic_field method, options.merge(as: :search_field), &block
  end

  def telephone_field(method, options = {}, &block)
    input_field method, options.merge(type: :tel), &block
  end

  alias_method :phone_field, :telephone_field
  
  def semantic_telephone_field(method, options = {}, &block)
    semantic_field method, options.merge(as: :telephone_field), &block
  end

  alias_method :semantic_phone_field, :semantic_telephone_field
  
  def date_field(method, options = {}, &block)
    input_field method, options.merge(type: :date), &block
  end

  def semantic_date_field(method, options = {}, &block)
    semantic_field method, options.merge(as: :date_field), &block
  end

  def datetime_field(method, options = {}, &block)
    input_field method, options.merge(type: :"datetime-local"), &block
  end

  alias_method :datetime_local_field, :datetime_field
  
  def semantic_datetime_field(method, options = {}, &block)
    semantic_field method, options.merge(as: :datetime_field), &block
  end

  alias_method :semantic_datetime_local_field, :semantic_datetime_field

  def time_field(method, options = {}, &block)
    input_field method, options.merge(type: :time), &block
  end

  def semantic_time_field(method, options = {}, &block)
    semantic_field method, options.merge(as: :time_field), &block
  end

  def month_field(method, options = {}, &block)
    input_field method, options.merge(type: :month), &block
  end

  def semantic_month_field(method, options = {}, &block)
    semantic_field method, options.merge(as: :month_field), &block
  end

  def week_field(method, options = {}, &block)
    input_field method, options.merge(type: :week), &block
  end

  def semantic_week_field(method, options = {}, &block)
    semantic_field method, options.merge(as: :week_field), &block
  end

  def url_field(method, options = {}, &block)
    input_field method, options.merge(type: :url), &block
  end

  def semantic_url_field(method, options = {}, &block)
    semantic_field method, options.merge(as: :url_field), &block
  end

  def email_field(method, options = {}, &block)
    input_field method, options.merge(type: :email), &block
  end

  def semantic_email_field(method, options = {}, &block)
    semantic_field method, options.merge(as: :email_field), &block
  end

  def number_field(method, options = {}, &block)
    input_field method, options.merge(type: :number), &block
  end

  def semantic_number_field(method, options = {}, &block)
    semantic_field method, options.merge(as: :number_field), &block
  end

  def input_field(method, options = {}, &block)
    options = objectify_component_options method, options
    @template.render FoxTail::InputComponent.new(options), &block
  end

  def semantic_field(method, options = {}, &block)
    options = objectify_component_options method, options
    @template.render FoxTail::SemanticFieldComponent.new(options), &block
  end

  def autocomplete_field(method, url, options = {}, &block)
    options = objectify_component_options method, options
    @template.render FoxTail::AutocompleteComponent.new(url, options), &block
  end

  def semantic_autocomplete_field(method, options = {}, &block)
    semantic_field method, options.merge(as: :autocomplete_field), &block
  end

  def range_field(method, options = {}, &block)
    options = objectify_component_options method, options
    @template.render FoxTail::RangeComponent.new(options), &block
  end

  def semantic_range_field(method, options = {}, &block)
    semantic_field method, options.merge(as: :range_field), &block
  end

  def text_area(method, options = {}, &block)
    options = objectify_component_options method, options
    @template.render FoxTail::TextareaComponent.new(options), &block
  end

  def semantic_text_area_field(method, options = {}, &block)
    semantic_field method, options.merge(as: :text_area), &block
  end

  def file_field(method, options = {}, &block)
    options = objectify_component_options method, options
    @template.render FoxTail::FileInputComponent.new(options), &block
  end

  def semantic_file_field(method, options = {}, &block)
    semantic_field method, options.merge(as: :file_field), &block
  end

  def dropzone_field(method, options = {}, &block)
    options = objectify_component_options method, options
    @template.render FoxTail::DropzoneComponent.new(options), &block
  end

  def semantic_dropzone_field(method, options = {}, &block)
    semantic_field method, options.merge(as: :dropzone_field), &block
  end

  def check_box(method, options = {}, checked_value = "1", unchecked_value = "0", &block)
    options = objectify_component_options method, options
    options[:checked_value] = checked_value
    options[:unchecked_value] = unchecked_value
    @template.render FoxTail::CheckboxComponent.new(options), &block
  end

  def semantic_check_box(method, options = {}, checked_value = "1", unchecked_value = "0", &block)
    options = objectify_component_options method, options
    options[:checked_value] = checked_value
    options[:unchecked_value] = unchecked_value
    options[:variant] ||= :inline
    semantic_field method, options.merge(as: :check_box), &block
  end

  def toggle_switch(method, options = {}, checked_value = "1", unchecked_value = "0", &block)
    options = objectify_component_options method, options
    options[:checked_value] = checked_value
    options[:unchecked_value] = unchecked_value
    @template.render FoxTail::ToggleComponent.new(options), &block
  end

  def semantic_toggle_switch(method, options = {}, checked_value = "1", unchecked_value = "0", &block)
    options = objectify_component_options method, options
    options[:checked_value] = checked_value
    options[:unchecked_value] = unchecked_value
    options[:variant] ||= :inline
    semantic_field method, options.merge(as: :toggle_switch), &block
  end

  def radio_button(method, tag_value, options = {}, &block)
    options = objectify_component_options method, options
    options[:value] = tag_value
    @template.render FoxTail::RadioButtonComponent.new(options), &block
  end

  def semantic_radio_button(method, tag_value, options = {}, &block)
    options = objectify_component_options method, options
    options[:value] = tag_value
    options[:variant] ||= :inline
    semantic_field method, options.merge(as: :radio_button), &block
  end

  def select(method, choices = nil, options = {}, html_options = {}, &block)
    options = objectify_component_options(method, options.merge(html_options))
    options[:placeholder] = options.delete(:placeholder) || options.delete(:prompt)
    options[:choices] = choices

    @template.render FoxTail::SelectComponent.new(options), &block
  end

  def semantic_select(method, choices = nil, options = {}, html_options = {}, &block)
    options = objectify_component_options(method, options.merge(html_options))
    options[:placeholder] = options.delete(:placeholder) || options.delete(:prompt)
    options[:choices] = choices

    semantic_field method, options.merge(as: :select), &block
  end

  def collection_select(method, collection, value_method, text_method, options = {}, html_options = {}, &block)
    choices = collection.map { |item| [item.send(text_method), item.send(value_method)] }
    select method, choices, options, html_options, &block
  end

  def semantic_collection_select(method, collection, value_method, text_method, options = {}, html_options = {}, &block)
    choices = collection.map { |item| [item.send(text_method), item.send(value_method)] }
    semantic_select method, choices, options, html_options, &block
  end

  def grouped_collection_select(method, collection, group_method, group_label_method, option_key_method, option_value_method, options = {}, html_options = {}, &block)
    select method, nil, options, html_options do |select_component|
      collection.each do |group|
        select_component.with_select_group group.send(group_label_method) do |group_component|
          group.send(group_method).each do |group_item|
            value = group_item.send option_key_method
            label = group_item.send option_value_method
            group_component.with_group_option(value).with_text(label)
          end
        end
      end

      capture select_component, &block if block
    end
  end

  def semantic_grouped_collection_select(method, collection, group_method, group_label_method, option_key_method, option_value_method, options = {}, html_options = {}, &block)
    semantic_select method, nil, options, html_options do |select_component|
      collection.each do |group|
        select_component.with_select_group group.send(group_label_method) do |group_component|
          group.send(group_method).each do |group_item|
            value = group_item.send option_key_method
            label = group_item.send option_value_method
            group_component.with_group_option(value).with_text(label)
          end
        end
      end

      capture select_component, &block if block
    end
  end

  def button(value = nil, options = {}, &block)
    if value.is_a? Hash
      options = value
      value = nil
    end

    options = objectify_component_options nil, options
    options[:value] ||= value
    component = FoxTail::ButtonComponent.new(options)
    component.with_content value if value.present?
    @template.render component, &block
  end

  def button_group(options = {}, &block)
    options = objectify_component_options nil, options
    @template.render FoxTail::ButtonGroupComponent.new(options), &block
  end

  def input_group(options = {}, &block)
    options = objectify_component_options nil, options
    @template.render FoxTail::InputGroupComponent.new(options), &block
  end

  def submit(value = nil, options = {}, &block)
    if value.is_a?(Hash)
      options = value
      value = nil
    end

    options[:type] = :submit

    button value, options, &block
  end

  # @todo Implement other form builder methods
  #
  # def collection_check_boxes(method, collection, value_method, text_method, options = nil, html_options = nil, &block)
  #   super
  # end
  #
  # def collection_radio_buttons(method, collection, value_method, text_method, options = {}, html_options = {}, &block)
  #   super
  # end
  #
  # def date_select(method, options = nil, html_options = nil)
  #   super
  # end
  #
  # def time_select(method, options = nil, html_options = nil)
  #   super
  # end
  #
  # def time_zone_select(method, priority_zones = nil, options = {}, html_options = {})
  #   super
  # end
  #
  # def datetime_select(method, options = nil, html_options = nil)
  #   super
  # end
  #
  # def weekday_select(method, options = nil, html_options = nil)
  #   super
  # end

  protected

  def objectify_component_options(method, options)
    result = objectify_options options
    result[:object_name] = object_name
    result[:method_name] = method
    result[:value_array] = self.options[:multiple] # Rename to prevent conflicts
    result[:object_index] = self.options[:index] # Rename to prevent conflicts
    result
  end
end
