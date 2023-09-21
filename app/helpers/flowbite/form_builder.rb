# frozen_string_literal: true

class Flowbite::FormBuilder < ActionView::Helpers::FormBuilder
  def label(method, text = nil, options = {}, &block)
    if text.is_a? Hash
      options = text
      text = nil
    end

    options = objectify_component_options method, options
    component = Flowbite::LabelComponent.new options
    component.with_content text if !block && text.present?
    @template.render component, &block
  end

  def help_text(method, text = nil, options = {}, &block)
    if text.is_a?(Hash)
      options = text
      text = nil
    end

    options = objectify_component_options method, options
    component = Flowbite::HelperTextComponent.new options
    component.with_content text unless text.blank?
    @template.render component, &block
  end

  def error_list(method, options = {}, &block)
    options = objectify_component_options method, options
    @template.render Flowbite::InputErrorListComponent.new(options), &block
  end

  def text_field(method, options = {}, &block)
    input_field method, options.merge(type: :text), &block
  end

  def password_field(method, options = {}, &block)
    input_field method, options.merge(type: :password), &block
  end

  def color_field(method, options = {}, &block)
    input_field method, options.merge(type: :color), &block
  end

  def search_field(method, options = {}, &block)
    input_field method, options.merge(type: :search), &block
  end

  def telephone_field(method, options = {}, &block)
    input_field method, options.merge(type: :tel), &block
  end

  alias_method :phone_field, :telephone_field

  def date_field(method, options = {}, &block)
    input_field method, options.merge(type: :date), &block
  end

  def datetime_field(method, options = {}, &block)
    input_field method, options.merge(type: :"datetime-local"), &block
  end

  alias_method :datetime_local_field, :datetime_field

  def time_field(method, options = {}, &block)
    input_field method, options.merge(type: :time), &block
  end

  def month_field(method, options = {}, &block)
    input_field method, options.merge(type: :month), &block
  end

  def week_field(method, options = {}, &block)
    input_field method, options.merge(type: :week), &block
  end

  def url_field(method, options = {}, &block)
    input_field method, options.merge(type: :url), &block
  end

  def email_field(method, options = {}, &block)
    input_field method, options.merge(type: :email), &block
  end

  def number_field(method, options = {}, &block)
    input_field method, options.merge(type: :number), &block
  end

  def input_field(method, options = {}, &block)
    options = objectify_component_options method, options
    @template.render Flowbite::InputComponent.new(options), &block
  end

  def range_field(method, options = {}, &block)
    options = objectify_component_options method, options
    @template.render Flowbite::RangeComponent.new(options), &block
  end

  def text_area(method, options = {}, &block)
    options = objectify_component_options method, options
    @template.render Flowbite::TextareaComponent.new(options), &block
  end

  def file_field(method, options = {}, &block)
    options = objectify_component_options method, options
    @template.render Flowbite::FileInputComponent.new(options), &block
  end

  def dropzone_field(method, options = {}, &block)
    options = objectify_component_options method, options
    @template.render Flowbite::DropzoneComponent.new(options), &block
  end

  def check_box(method, options = {}, checked_value = "1", unchecked_value = "0", &block)
    options = objectify_component_options method, options
    options[:checked_value] = checked_value
    options[:unchecked_value] = unchecked_value
    @template.render Flowbite::CheckboxComponent.new(options), &block
  end

  def radio_button(method, tag_value, options = {}, &block)
    options = objectify_component_options method, options
    options[:value] = tag_value
    @template.render Flowbite::RadioButtonComponent.new(options), &block
  end

  def select(method, choices = nil, options = {}, html_options = {}, &block)
    include_blank = options.delete :include_blank
    prompt = options.delete :prompt
    options = objectify_component_options(method, options.merge(html_options))
    choices = choices.to_a if choices.is_a? Range

    @template.render Flowbite::SelectComponent.new(options) do |select|
      if !!prompt
        select.with_placeholder prompt_text(prompt)
      elsif !!include_blank
        select.with_placeholder "", disabled: false
      end

      if choices.present?
        choices.each do |choice|
          choice_options = option_html_attributes choice
          text, value = option_text_and_value choice
          select.with_select_option(value, choice_options).with_content(text)
        end
      end

      capture select, &block if block
    end
  end

  def collection_select(method, collection, value_method, text_method, options = {}, html_options = {}, &block)
    choices = collection.map { |item| [item.send(text_method), item.send(value_method)] }
    select method, choices, options, html_options, &block
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

  def button(value = nil, options = {}, &block)
    if value.is_a? Hash
      value = nil
      options = value
    end

    options = objectify_component_options nil, options
    options[:value] ||= value
    component = Flowbite::ButtonComponent.new(options)
    component.with_content value if value.present?
    @template.render component, &block
  end

  def button_group(options = {}, &block)
    options = objectify_component_options nil, options
    @template.render Flowbite::ButtonGroupComponent.new(options), &block
  end

  def input_group(options = {}, &block)
    options = objectify_component_options nil, options
    @template.render Flowbite::InputGroupComponent.new(options), &block
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
